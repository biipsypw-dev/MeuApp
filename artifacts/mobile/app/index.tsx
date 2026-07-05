import React, { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  TouchableOpacity,
  TextInput,
  ScrollView,
  StyleSheet,
  BackHandler,
  Alert,
  Linking,
  Platform,
  TouchableWithoutFeedback,
} from 'react-native';
import Animated, {
  useSharedValue,
  useAnimatedStyle,
  withTiming,
} from 'react-native-reanimated';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { Ionicons, MaterialIcons } from '@expo/vector-icons';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as Haptics from 'expo-haptics';

// ─────────────────────────────────────────────────────
// Dark navy palette — mirrors android_project design
// ─────────────────────────────────────────────────────
const C = {
  bg: '#0A0F1E',
  card: '#111827',
  toolbar: '#0D1B2A',
  drawerBg: '#0A0F1E',
  fg: '#FFFFFF',
  muted: '#7986CB',
  dimmed: '#90CAF9',
  alarm: '#E53935',
  alarmP: '#B71C1C',
  notes: '#43A047',
  notesP: '#1B5E20',
  music: '#8E24AA',
  musicP: '#4A148C',
  weather: '#00ACC1',
  weatherP: '#006064',
  neutral: '#1A2540',
  neutralP: '#2D4060',
  divider: '#1E2D45',
  statusGreen: '#4CAF50',
  border: '#2D4060',
} as const;

const DRAWER_WIDTH = 280;
const NOTE_KEY = 'meuapp_nota';

type Panel = 'clock' | 'notes' | 'alarm' | 'music' | 'weather';

// ─────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────
const DAYS_PT = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
const MONTHS_PT = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];

function pad(n: number) {
  return String(n).padStart(2, '0');
}
function fmtTime(d: Date) {
  return `${pad(d.getHours())}:${pad(d.getMinutes())}:${pad(d.getSeconds())}`;
}
function fmtDate(d: Date) {
  return `${DAYS_PT[d.getDay()]}, ${pad(d.getDate())} ${MONTHS_PT[d.getMonth()]} ${d.getFullYear()}`;
}

// ─────────────────────────────────────────────────────
// Main screen
// ─────────────────────────────────────────────────────
export default function HomeScreen() {
  const insets = useSafeAreaInsets();
  const topPad = Platform.OS === 'web' ? 67 : insets.top;
  const botPad = Platform.OS === 'web' ? 34 : insets.bottom;

  // Clock
  const [now, setNow] = useState(new Date());
  useEffect(() => {
    const id = setInterval(() => setNow(new Date()), 1000);
    return () => clearInterval(id);
  }, []);

  // Panels & drawer
  const [activePanel, setActivePanel] = useState<Panel>('clock');
  const [drawerOpen, setDrawerOpen] = useState(false);

  // Notes
  const [noteText, setNoteText] = useState('');
  useEffect(() => {
    AsyncStorage.getItem(NOTE_KEY).then(v => { if (v !== null) setNoteText(v); });
  }, []);

  // Alarm time picker
  const [alarmH, setAlarmH] = useState(new Date().getHours());
  const [alarmM, setAlarmM] = useState(new Date().getMinutes());

  // Drawer animation (react-native-reanimated)
  const drawerX = useSharedValue(-DRAWER_WIDTH);
  const overlayAlpha = useSharedValue(0);

  const drawerStyle = useAnimatedStyle(() => ({
    transform: [{ translateX: drawerX.value }],
  }));
  const overlayStyle = useAnimatedStyle(() => ({
    opacity: overlayAlpha.value,
  }));

  // Android back button
  useEffect(() => {
    if (Platform.OS !== 'android') return;
    const sub = BackHandler.addEventListener('hardwareBackPress', () => {
      if (drawerOpen) { closeDrawer(); return true; }
      if (activePanel !== 'clock') { setActivePanel('clock'); return true; }
      return false;
    });
    return () => sub.remove();
  }, [drawerOpen, activePanel]);

  const openDrawer = useCallback(() => {
    setDrawerOpen(true);
    drawerX.value = withTiming(0, { duration: 260 });
    overlayAlpha.value = withTiming(1, { duration: 260 });
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
  }, []);

  const closeDrawer = useCallback(() => {
    drawerX.value = withTiming(-DRAWER_WIDTH, { duration: 260 });
    overlayAlpha.value = withTiming(0, { duration: 260 });
    setDrawerOpen(false);
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
  }, []);

  const openPanel = useCallback((panel: Panel) => {
    Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
    if (panel === 'notes') {
      AsyncStorage.getItem(NOTE_KEY).then(v => { if (v !== null) setNoteText(v); });
    }
    if (panel === 'alarm') {
      const n = new Date();
      setAlarmH(n.getHours());
      setAlarmM(n.getMinutes());
    }
    setActivePanel(panel);
  }, []);

  const saveNote = useCallback(async () => {
    await AsyncStorage.setItem(NOTE_KEY, noteText);
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
    setActivePanel('clock');
  }, [noteText]);

  const confirmAlarm = useCallback(() => {
    const url =
      Platform.OS === 'android'
        ? `intent:#Intent;action=android.intent.action.SET_ALARM;i.android.intent.extra.alarm.HOUR=${alarmH};i.android.intent.extra.alarm.MINUTES=${alarmM};S.android.intent.extra.alarm.MESSAGE=MeuApp;end`
        : `clock:alarm`;
    Linking.openURL(url).catch(() =>
      Alert.alert('Alarme', `Alarme configurado para ${pad(alarmH)}:${pad(alarmM)}`)
    );
    Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
  }, [alarmH, alarmM]);

  const launchMusic = useCallback(() => {
    Linking.openURL(Platform.OS === 'ios' ? 'music://' : 'content://media/internal/audio/media').catch(() =>
      Alert.alert('Música', 'Nenhum player de música encontrado.')
    );
    setActivePanel('clock');
  }, []);

  const launchWeather = useCallback(() => {
    Linking.openURL('https://www.google.com/search?q=previsao+do+tempo');
    setActivePanel('clock');
  }, []);

  return (
    <View style={[styles.root, { paddingTop: topPad }]}>

      {/* ══ TOP SECTION (40%) — painéis ══════════════ */}
      <View style={styles.topSection}>

        {/* RELÓGIO */}
        {activePanel === 'clock' && (
          <View style={styles.centerFill}>
            <Text style={styles.clockText}>{fmtTime(now)}</Text>
            <Text style={styles.dateText}>{fmtDate(now)}</Text>
          </View>
        )}

        {/* NOTAS */}
        {activePanel === 'notes' && (
          <View style={styles.panel}>
            <Text style={styles.panelTitle}>Notas</Text>
            <TextInput
              style={styles.noteInput}
              value={noteText}
              onChangeText={setNoteText}
              placeholder="Escreva aqui..."
              placeholderTextColor={C.muted}
              multiline
              textAlignVertical="top"
            />
            <View style={styles.btnRow}>
              <PanelBtn color={C.notes} onPress={saveNote} flex={2}>
                <Ionicons name="checkmark" size={16} color={C.fg} />
                <Text style={styles.btnLabel}>Salvar</Text>
              </PanelBtn>
              <PanelBtn color={C.neutral} onPress={() => setNoteText('')}>
                <Ionicons name="trash-outline" size={16} color={C.fg} />
              </PanelBtn>
              <PanelBtn color={C.neutral} onPress={() => setActivePanel('clock')}>
                <Ionicons name="close" size={16} color={C.fg} />
              </PanelBtn>
            </View>
          </View>
        )}

        {/* ALARME */}
        {activePanel === 'alarm' && (
          <View style={[styles.panel, styles.centerFill]}>
            <Text style={styles.panelTitle}>Alarme</Text>
            <View style={styles.timePicker}>
              <TimeUnit value={alarmH} max={23} onChange={setAlarmH} color={C.alarm} />
              <Text style={styles.timeSep}>:</Text>
              <TimeUnit value={alarmM} max={59} onChange={setAlarmM} color={C.alarm} />
            </View>
            <View style={styles.btnRow}>
              <PanelBtn color={C.alarm} onPress={confirmAlarm} flex={2}>
                <Ionicons name="alarm-outline" size={16} color={C.fg} />
                <Text style={styles.btnLabel}>Definir Alarme</Text>
              </PanelBtn>
              <PanelBtn color={C.neutral} onPress={() => setActivePanel('clock')}>
                <Ionicons name="close" size={16} color={C.fg} />
              </PanelBtn>
            </View>
          </View>
        )}

        {/* MÚSICA */}
        {activePanel === 'music' && (
          <View style={[styles.panel, styles.centerFill]}>
            <MaterialIcons name="library-music" size={44} color={C.music} style={{ marginBottom: 10 }} />
            <Text style={styles.panelTitle}>Música</Text>
            <Text style={styles.panelDesc}>Abre o reprodutor padrão do dispositivo.</Text>
            <View style={styles.btnRow}>
              <PanelBtn color={C.music} onPress={launchMusic} flex={2}>
                <Ionicons name="play-circle-outline" size={18} color={C.fg} />
                <Text style={styles.btnLabel}>Abrir Player</Text>
              </PanelBtn>
              <PanelBtn color={C.neutral} onPress={() => setActivePanel('clock')}>
                <Ionicons name="close" size={16} color={C.fg} />
              </PanelBtn>
            </View>
          </View>
        )}

        {/* CLIMA */}
        {activePanel === 'weather' && (
          <View style={[styles.panel, styles.centerFill]}>
            <Ionicons name="partly-sunny-outline" size={44} color={C.weather} style={{ marginBottom: 10 }} />
            <Text style={styles.panelTitle}>Clima</Text>
            <Text style={styles.panelDesc}>Consulta a previsão do tempo no navegador.</Text>
            <View style={styles.btnRow}>
              <PanelBtn color={C.weather} onPress={launchWeather} flex={2}>
                <Ionicons name="open-outline" size={18} color={C.fg} />
                <Text style={styles.btnLabel}>Ver Previsão</Text>
              </PanelBtn>
              <PanelBtn color={C.neutral} onPress={() => setActivePanel('clock')}>
                <Ionicons name="close" size={16} color={C.fg} />
              </PanelBtn>
            </View>
          </View>
        )}

      </View>
      {/* ══ FIM TOP SECTION ════════════════════════════ */}

      {/* ══ BOTTOM SECTION (60%) — toolbar + botões ═══ */}
      <View style={styles.bottomSection}>

        {/* TOOLBAR */}
        <View style={styles.toolbar}>
          <TouchableOpacity onPress={openDrawer} style={styles.menuBtn} hitSlop={8}>
            <Ionicons name="menu" size={26} color={C.fg} />
          </TouchableOpacity>
          <Text style={styles.appName}>MeuApp</Text>
          <View style={styles.statusDot} />
          <Text style={styles.statusLabel}>Ativo</Text>
        </View>

        {/* ESPAÇO FLEXÍVEL */}
        <View style={{ flex: 1 }} />

        {/* GRADE 2×2 */}
        <View style={[styles.btnGrid, { paddingBottom: Math.max(botPad, 20) }]}>
          <View style={styles.gridRow}>
            <GridBtn label="Alarme" icon="alarm-outline" color={C.alarm} pressedColor={C.alarmP}
              active={activePanel === 'alarm'} onPress={() => openPanel('alarm')} />
            <GridBtn label="Notas" icon="create-outline" color={C.notes} pressedColor={C.notesP}
              active={activePanel === 'notes'} onPress={() => openPanel('notes')} />
          </View>
          <View style={styles.gridRow}>
            <GridBtn label="Música" icon="musical-notes-outline" color={C.music} pressedColor={C.musicP}
              active={activePanel === 'music'} onPress={() => openPanel('music')} />
            <GridBtn label="Clima" icon="partly-sunny-outline" color={C.weather} pressedColor={C.weatherP}
              active={activePanel === 'weather'} onPress={() => openPanel('weather')} />
          </View>
        </View>

      </View>
      {/* ══ FIM BOTTOM SECTION ═════════════════════════ */}

      {/* ══ OVERLAY — escurece ao abrir o menu ═════════ */}
      <Animated.View
        pointerEvents={drawerOpen ? 'auto' : 'none'}
        style={[StyleSheet.absoluteFillObject, styles.overlay, overlayStyle]}
      >
        <TouchableWithoutFeedback onPress={closeDrawer}>
          <View style={StyleSheet.absoluteFillObject} />
        </TouchableWithoutFeedback>
      </Animated.View>

      {/* ══ DRAWER — desliza da esquerda ═══════════════ */}
      <Animated.View style={[styles.drawer, { paddingTop: topPad }, drawerStyle]}>

        {/* Cabeçalho */}
        <View style={styles.drawerHead}>
          <TouchableOpacity onPress={closeDrawer} style={styles.drawerCloseBtn} hitSlop={8}>
            <Ionicons name="close" size={22} color={C.fg} />
          </TouchableOpacity>
          <Text style={styles.drawerTitle}>Menu</Text>
        </View>
        <View style={styles.divider} />

        <ScrollView contentContainerStyle={{ paddingBottom: 24 }}>
          <Text style={styles.soonLabel}>Em breve...</Text>
          <DrawerItem icon="settings-outline" label="Configurações" />
          <DrawerItem icon="notifications-outline" label="Notificações" />
          <DrawerItem icon="bar-chart-outline" label="Estatísticas" />
          <DrawerItem icon="color-palette-outline" label="Personalizar" />
          <DrawerItem icon="information-circle-outline" label="Sobre o App" />
          <View style={[styles.divider, { marginTop: 12 }]} />
          <Text style={styles.versionLabel}>Versão 1.0</Text>
        </ScrollView>

      </Animated.View>

    </View>
  );
}

// ─────────────────────────────────────────────────────
// Sub-components
// ─────────────────────────────────────────────────────

/** Seletor de hora/minuto com botões ▲ ▼ */
function TimeUnit({
  value, max, onChange, color,
}: {
  value: number;
  max: number;
  onChange: (v: number) => void;
  color: string;
}) {
  const inc = () => onChange((value + 1) % (max + 1));
  const dec = () => onChange((value - 1 + max + 1) % (max + 1));
  return (
    <View style={styles.timeUnit}>
      <TouchableOpacity onPress={inc} style={styles.timeArrow} hitSlop={8}>
        <Ionicons name="chevron-up" size={28} color={color} />
      </TouchableOpacity>
      <Text style={styles.timeDigits}>{pad(value)}</Text>
      <TouchableOpacity onPress={dec} style={styles.timeArrow} hitSlop={8}>
        <Ionicons name="chevron-down" size={28} color={color} />
      </TouchableOpacity>
    </View>
  );
}

/** Botão compacto dentro dos painéis */
function PanelBtn({
  color, onPress, children, flex,
}: {
  color: string;
  onPress: () => void;
  children: React.ReactNode;
  flex?: number;
}) {
  return (
    <TouchableOpacity
      style={[styles.panelBtn, { backgroundColor: color, flex: flex ?? 1 }]}
      onPress={onPress}
      activeOpacity={0.75}
    >
      {children}
    </TouchableOpacity>
  );
}

/** Botão da grade 2×2 */
function GridBtn({
  label, icon, color, pressedColor, active, onPress,
}: {
  label: string;
  icon: string;
  color: string;
  pressedColor: string;
  active: boolean;
  onPress: () => void;
}) {
  return (
    <TouchableOpacity
      style={[styles.gridBtn, { backgroundColor: active ? pressedColor : color }]}
      onPress={onPress}
      activeOpacity={0.75}
    >
      <Ionicons name={icon as any} size={28} color="#FFFFFF" />
      <Text style={styles.gridBtnLabel}>{label}</Text>
    </TouchableOpacity>
  );
}

/** Item decorativo do menu lateral (sem função) */
function DrawerItem({ icon, label }: { icon: string; label: string }) {
  return (
    <>
      <View style={styles.drawerItem}>
        <Ionicons name={icon as any} size={20} color={C.dimmed} style={{ marginRight: 14 }} />
        <Text style={styles.drawerItemText}>{label}</Text>
      </View>
      <View style={styles.divider} />
    </>
  );
}

// ─────────────────────────────────────────────────────
// Styles
// ─────────────────────────────────────────────────────
const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: C.bg,
  },

  // Sections
  topSection: {
    flex: 4,
    backgroundColor: C.bg,
  },
  bottomSection: {
    flex: 6,
    backgroundColor: C.card,
  },
  centerFill: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },

  // Clock
  clockText: {
    fontSize: 58,
    color: C.fg,
    fontFamily: 'Inter_700Bold',
    letterSpacing: 3,
  },
  dateText: {
    fontSize: 15,
    color: C.muted,
    fontFamily: 'Inter_400Regular',
    marginTop: 8,
    letterSpacing: 1,
  },

  // Panel shared
  panel: {
    flex: 1,
    padding: 18,
  },
  panelTitle: {
    fontSize: 17,
    color: C.fg,
    fontFamily: 'Inter_700Bold',
    marginBottom: 10,
  },
  panelDesc: {
    fontSize: 13,
    color: C.muted,
    fontFamily: 'Inter_400Regular',
    textAlign: 'center',
    marginTop: 6,
    marginBottom: 18,
    paddingHorizontal: 20,
  },

  // Notes
  noteInput: {
    flex: 1,
    backgroundColor: '#0D1420',
    borderColor: C.border,
    borderWidth: 1,
    borderRadius: 10,
    color: C.fg,
    padding: 12,
    fontSize: 15,
    fontFamily: 'Inter_400Regular',
  },

  // Panel buttons
  btnRow: {
    flexDirection: 'row',
    gap: 8,
    marginTop: 10,
  },
  panelBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
    height: 40,
    borderRadius: 12,
  },
  btnLabel: {
    color: C.fg,
    fontSize: 13,
    fontFamily: 'Inter_600SemiBold',
  },

  // Time picker
  timePicker: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginVertical: 4,
    gap: 2,
  },
  timeUnit: {
    alignItems: 'center',
  },
  timeArrow: {
    padding: 4,
  },
  timeDigits: {
    fontSize: 52,
    color: C.fg,
    fontFamily: 'Inter_700Bold',
    letterSpacing: 2,
    minWidth: 74,
    textAlign: 'center',
  },
  timeSep: {
    fontSize: 52,
    color: C.fg,
    fontFamily: 'Inter_700Bold',
    marginBottom: 4,
    marginHorizontal: 2,
  },

  // Toolbar
  toolbar: {
    height: 56,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: C.toolbar,
    paddingHorizontal: 4,
    paddingEnd: 16,
  },
  menuBtn: {
    width: 48,
    height: 48,
    alignItems: 'center',
    justifyContent: 'center',
  },
  appName: {
    flex: 1,
    marginLeft: 6,
    color: C.fg,
    fontSize: 18,
    fontFamily: 'Inter_700Bold',
  },
  statusDot: {
    width: 7,
    height: 7,
    borderRadius: 4,
    backgroundColor: C.statusGreen,
    marginRight: 5,
  },
  statusLabel: {
    color: C.statusGreen,
    fontSize: 12,
    fontFamily: 'Inter_500Medium',
  },

  // Grid buttons
  btnGrid: {
    paddingHorizontal: 16,
  },
  gridRow: {
    flexDirection: 'row',
    gap: 10,
    marginBottom: 10,
  },
  gridBtn: {
    flex: 1,
    height: 88,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
  },
  gridBtnLabel: {
    color: '#FFFFFF',
    fontSize: 13,
    fontFamily: 'Inter_600SemiBold',
  },

  // Overlay
  overlay: {
    backgroundColor: 'rgba(0,0,0,0.55)',
  },

  // Drawer
  drawer: {
    position: 'absolute',
    left: 0,
    top: 0,
    bottom: 0,
    width: DRAWER_WIDTH,
    backgroundColor: C.drawerBg,
    elevation: 16,
    shadowColor: '#000',
    shadowOffset: { width: 4, height: 0 },
    shadowOpacity: 0.5,
    shadowRadius: 10,
  },
  drawerHead: {
    flexDirection: 'row',
    alignItems: 'center',
    height: 64,
    paddingHorizontal: 6,
  },
  drawerCloseBtn: {
    width: 48,
    height: 48,
    alignItems: 'center',
    justifyContent: 'center',
  },
  drawerTitle: {
    color: C.fg,
    fontSize: 19,
    fontFamily: 'Inter_700Bold',
    marginLeft: 6,
  },
  divider: {
    height: 1,
    backgroundColor: C.divider,
  },
  soonLabel: {
    color: C.muted,
    fontSize: 10,
    letterSpacing: 1.5,
    paddingHorizontal: 20,
    paddingTop: 16,
    paddingBottom: 8,
    fontFamily: 'Inter_500Medium',
    textTransform: 'uppercase',
  },
  drawerItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingVertical: 14,
  },
  drawerItemText: {
    color: C.dimmed,
    fontSize: 15,
    fontFamily: 'Inter_500Medium',
  },
  versionLabel: {
    color: C.divider,
    fontSize: 11,
    paddingHorizontal: 20,
    paddingTop: 20,
    fontFamily: 'Inter_400Regular',
  },
});
