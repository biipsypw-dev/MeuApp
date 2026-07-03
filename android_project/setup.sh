#!/bin/bash
#=================================================
# SETUP.SH — Gerador automático do projeto Android
# Execute no Termux: bash setup.sh
# Cria toda a estrutura de pastas e arquivos.
# Versão com design melhorado e funções reais.
#=================================================

PROJECT="meuapp"

echo ""
echo "========================================"
echo "  Criando projeto: $PROJECT"
echo "========================================"

#─────────────────────────────────────────────
# BLOCO 1 — CRIAÇÃO DE DIRETÓRIOS
#─────────────────────────────────────────────
echo "[1/9] Criando estrutura de diretórios..."

mkdir -p "$PROJECT/src/com/meuapp"
mkdir -p "$PROJECT/res/layout"
mkdir -p "$PROJECT/res/values"
mkdir -p "$PROJECT/res/drawable"

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 2 — AndroidManifest.xml
#─────────────────────────────────────────────
echo "[2/9] Criando AndroidManifest.xml..."

cat > "$PROJECT/AndroidManifest.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.meuapp"
    android:versionCode="1"
    android:versionName="1.0">

    <uses-sdk
        android:minSdkVersion="21"
        android:targetSdkVersion="34" />

    <application
        android:allowBackup="true"
        android:label="@string/app_name"
        android:theme="@style/AppTheme"
        android:supportsRtl="true">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/AppTheme"
            android:windowSoftInputMode="stateHidden">

            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>

        </activity>

    </application>

</manifest>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 3 — DRAWABLES (botões arredondados)
#─────────────────────────────────────────────
echo "[3/9] Criando res/drawable/ (botões com bordas arredondadas)..."

cat > "$PROJECT/res/drawable/btn_alarme.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_pressed="true">
        <shape android:shape="rectangle">
            <solid android:color="#B71C1C"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
    <item>
        <shape android:shape="rectangle">
            <solid android:color="#E53935"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
</selector>
ENDOFFILE

cat > "$PROJECT/res/drawable/btn_notas.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_pressed="true">
        <shape android:shape="rectangle">
            <solid android:color="#1B5E20"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
    <item>
        <shape android:shape="rectangle">
            <solid android:color="#43A047"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
</selector>
ENDOFFILE

cat > "$PROJECT/res/drawable/btn_musica.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_pressed="true">
        <shape android:shape="rectangle">
            <solid android:color="#4A148C"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
    <item>
        <shape android:shape="rectangle">
            <solid android:color="#8E24AA"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
</selector>
ENDOFFILE

cat > "$PROJECT/res/drawable/btn_clima.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_pressed="true">
        <shape android:shape="rectangle">
            <solid android:color="#006064"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
    <item>
        <shape android:shape="rectangle">
            <solid android:color="#00ACC1"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
</selector>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 4 — activity_main.xml
#─────────────────────────────────────────────
echo "[4/9] Criando res/layout/activity_main.xml..."

cat > "$PROJECT/res/layout/activity_main.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<!--=================================================
    LAYOUT PRINCIPAL — activity_main.xml
    Estrutura:
      CAMADA 1 — Conteúdo principal
        ├─ Seção superior: Relógio + Data
        └─ Seção inferior: Toolbar + Botões 2x2
      CAMADA 2 — Menu lateral (sobreposto)
=================================================-->
<FrameLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">


    <!--═══════════════════════════════════════════
        CAMADA 1 — CONTEÚDO PRINCIPAL
    ═══════════════════════════════════════════-->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical">


        <!--── SEÇÃO SUPERIOR: RELÓGIO + DATA ───────-->
        <FrameLayout
            android:id="@+id/section_top"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="2"
            android:background="@color/section_top">

            <LinearLayout
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_gravity="center"
                android:orientation="vertical"
                android:gravity="center">

                <!-- Relógio principal -->
                <TextView
                    android:id="@+id/tv_clock"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="00:00:00"
                    android:textSize="64sp"
                    android:textColor="@color/text_light"
                    android:fontFamily="monospace"
                    android:letterSpacing="0.05" />

                <!-- Data abaixo do relógio -->
                <TextView
                    android:id="@+id/tv_date"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="4dp"
                    android:text="Seg, 01 Jan 2025"
                    android:textSize="16sp"
                    android:textColor="@color/text_date"
                    android:letterSpacing="0.08" />

            </LinearLayout>
        </FrameLayout>


        <!--── SEÇÃO INFERIOR: TOOLBAR + BOTÕES ─────-->
        <LinearLayout
            android:id="@+id/section_bottom"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="8"
            android:orientation="vertical"
            android:background="@color/section_bottom">


            <!--── TOOLBAR ───────────────────────────-->
            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="56dp"
                android:orientation="horizontal"
                android:gravity="center_vertical"
                android:background="@color/toolbar_bg"
                android:paddingStart="4dp"
                android:paddingEnd="16dp">

                <Button
                    android:id="@+id/btn_menu"
                    android:layout_width="48dp"
                    android:layout_height="48dp"
                    android:text="&#9776;"
                    android:textSize="24sp"
                    android:textColor="@color/text_light"
                    android:background="?android:attr/selectableItemBackgroundBorderless"
                    android:contentDescription="@string/menu_desc"
                    android:padding="0dp" />

                <TextView
                    android:layout_width="0dp"
                    android:layout_height="wrap_content"
                    android:layout_weight="1"
                    android:layout_marginStart="8dp"
                    android:text="@string/app_name"
                    android:textColor="@color/text_light"
                    android:textSize="18sp"
                    android:textStyle="bold" />

                <TextView
                    android:id="@+id/tv_status"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/status_ativo"
                    android:textColor="@color/text_status"
                    android:textSize="12sp" />

            </LinearLayout>


            <!-- Espaço flexível: empurra botões para baixo -->
            <View
                android:layout_width="match_parent"
                android:layout_height="0dp"
                android:layout_weight="1" />


            <!--── GRADE DE BOTÕES 2x2 ────────────────-->
            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:paddingStart="20dp"
                android:paddingEnd="20dp"
                android:paddingBottom="24dp">

                <!-- Linha superior: Alarme | Notas -->
                <LinearLayout
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:orientation="horizontal">

                    <Button
                        android:id="@+id/btn_alarme"
                        android:layout_width="0dp"
                        android:layout_height="90dp"
                        android:layout_weight="1"
                        android:layout_marginEnd="8dp"
                        android:layout_marginBottom="8dp"
                        android:text="&#9200;&#10;Alarme"
                        android:textColor="@color/text_light"
                        android:textSize="14sp"
                        android:background="@drawable/btn_alarme" />

                    <Button
                        android:id="@+id/btn_notas"
                        android:layout_width="0dp"
                        android:layout_height="90dp"
                        android:layout_weight="1"
                        android:layout_marginStart="8dp"
                        android:layout_marginBottom="8dp"
                        android:text="&#128221;&#10;Notas"
                        android:textColor="@color/text_light"
                        android:textSize="14sp"
                        android:background="@drawable/btn_notas" />

                </LinearLayout>

                <!-- Linha inferior: Música | Clima -->
                <LinearLayout
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:orientation="horizontal">

                    <Button
                        android:id="@+id/btn_musica"
                        android:layout_width="0dp"
                        android:layout_height="90dp"
                        android:layout_weight="1"
                        android:layout_marginEnd="8dp"
                        android:text="&#127925;&#10;Música"
                        android:textColor="@color/text_light"
                        android:textSize="14sp"
                        android:background="@drawable/btn_musica" />

                    <Button
                        android:id="@+id/btn_clima"
                        android:layout_width="0dp"
                        android:layout_height="90dp"
                        android:layout_weight="1"
                        android:layout_marginStart="8dp"
                        android:text="&#127780;&#10;Clima"
                        android:textColor="@color/text_light"
                        android:textSize="14sp"
                        android:background="@drawable/btn_clima" />

                </LinearLayout>

            </LinearLayout>

        </LinearLayout>

    </LinearLayout>
    <!--══ FIM CAMADA 1 ═════════════════════════-->


    <!--═══════════════════════════════════════════
        CAMADA 2 — MENU LATERAL
    ═══════════════════════════════════════════-->
    <FrameLayout
        android:id="@+id/nav_drawer"
        android:layout_width="250dp"
        android:layout_height="match_parent"
        android:background="@color/drawer_bg"
        android:visibility="gone">

        <Button
            android:id="@+id/btn_close_drawer"
            android:layout_width="48dp"
            android:layout_height="48dp"
            android:layout_gravity="top|start"
            android:layout_margin="8dp"
            android:text="&#10005;"
            android:textSize="20sp"
            android:textColor="@color/text_light"
            android:background="?android:attr/selectableItemBackgroundBorderless"
            android:contentDescription="@string/close_menu_desc"
            android:padding="0dp" />

        <ScrollView
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:layout_marginTop="64dp">

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:paddingStart="16dp"
                android:paddingEnd="16dp"
                android:paddingBottom="24dp">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/drawer_title"
                    android:textSize="26sp"
                    android:textColor="@color/text_light"
                    android:textStyle="bold"
                    android:layout_marginBottom="24dp" />

                <View
                    android:layout_width="match_parent"
                    android:layout_height="1dp"
                    android:background="@color/divider"
                    android:layout_marginBottom="16dp" />

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Última nota:"
                    android:textColor="@color/text_date"
                    android:textSize="12sp"
                    android:layout_marginBottom="4dp" />

                <TextView
                    android:id="@+id/tv_nota_salva"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="Nenhuma nota ainda."
                    android:textColor="@color/text_light"
                    android:textSize="14sp"
                    android:background="@color/drawer_item_bg"
                    android:padding="12dp" />

                <View
                    android:layout_width="match_parent"
                    android:layout_height="1dp"
                    android:background="@color/divider"
                    android:layout_marginTop="24dp"
                    android:layout_marginBottom="16dp" />

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Versão 1.0"
                    android:textColor="@color/text_date"
                    android:textSize="12sp" />

            </LinearLayout>
        </ScrollView>

    </FrameLayout>
    <!--══ FIM CAMADA 2 ═════════════════════════-->


</FrameLayout>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 5 — MainActivity.java
#─────────────────────────────────────────────
echo "[5/9] Criando src/com/meuapp/MainActivity.java..."

cat > "$PROJECT/src/com/meuapp/MainActivity.java" << 'ENDOFFILE'
package com.meuapp;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.AlarmClock;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class MainActivity extends Activity {

    //── Views principais ─────────────────────────
    private TextView    tvClock;
    private TextView    tvDate;
    private TextView    tvNotaSalva;
    private FrameLayout navDrawer;
    private Button      btnMenu;
    private Button      btnCloseDrawer;

    //── Botões de ação ───────────────────────────
    private Button btnAlarme;
    private Button btnNotas;
    private Button btnMusica;
    private Button btnClima;

    //── Relógio ──────────────────────────────────
    private Handler  clockHandler;
    private Runnable clockRunnable;

    private static final SimpleDateFormat TIME_FORMAT =
            new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
    private static final SimpleDateFormat DATE_FORMAT =
            new SimpleDateFormat("EEE, dd MMM yyyy", new Locale("pt", "BR"));

    private static final long CLOCK_INTERVAL_MS = 1000L;
    private static final long ANIM_FADE_IN_MS   = 250L;
    private static final long ANIM_FADE_OUT_MS  = 180L;

    //── SharedPreferences ────────────────────────
    private static final String PREFS_NAME = "meuapp_prefs";
    private static final String KEY_NOTA   = "ultima_nota";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initViews();
        initClock();
        initDrawer();
        initBotoes();
        carregarNotaSalva();
    }

    //─────────────────────────────────────────────
    // INICIALIZAÇÃO DE VIEWS
    //─────────────────────────────────────────────
    private void initViews() {
        tvClock        = findViewById(R.id.tv_clock);
        tvDate         = findViewById(R.id.tv_date);
        tvNotaSalva    = findViewById(R.id.tv_nota_salva);
        navDrawer      = findViewById(R.id.nav_drawer);
        btnMenu        = findViewById(R.id.btn_menu);
        btnCloseDrawer = findViewById(R.id.btn_close_drawer);
        btnAlarme      = findViewById(R.id.btn_alarme);
        btnNotas       = findViewById(R.id.btn_notas);
        btnMusica      = findViewById(R.id.btn_musica);
        btnClima       = findViewById(R.id.btn_clima);
    }

    //─────────────────────────────────────────────
    // RELÓGIO + DATA EM TEMPO REAL
    //─────────────────────────────────────────────
    private void initClock() {
        clockHandler = new Handler(Looper.getMainLooper());
        clockRunnable = new Runnable() {
            @Override
            public void run() {
                Date agora = new Date();
                tvClock.setText(TIME_FORMAT.format(agora));
                tvDate.setText(DATE_FORMAT.format(agora));
                clockHandler.postDelayed(this, CLOCK_INTERVAL_MS);
            }
        };
    }

    //─────────────────────────────────────────────
    // MENU LATERAL (DRAWER)
    //─────────────────────────────────────────────
    private void initDrawer() {
        btnMenu.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { openDrawer(); }
        });
        btnCloseDrawer.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { closeDrawer(); }
        });
    }

    private void openDrawer() {
        navDrawer.clearAnimation();
        navDrawer.setVisibility(View.VISIBLE);
        AlphaAnimation fadeIn = new AlphaAnimation(0f, 1f);
        fadeIn.setDuration(ANIM_FADE_IN_MS);
        fadeIn.setFillAfter(true);
        navDrawer.startAnimation(fadeIn);
    }

    private void closeDrawer() {
        navDrawer.clearAnimation();
        final boolean[] cancelled = {false};
        AlphaAnimation fadeOut = new AlphaAnimation(1f, 0f);
        fadeOut.setDuration(ANIM_FADE_OUT_MS);
        fadeOut.setFillAfter(true);
        fadeOut.setAnimationListener(new Animation.AnimationListener() {
            @Override public void onAnimationStart(Animation a)  {}
            @Override public void onAnimationRepeat(Animation a) {}
            @Override
            public void onAnimationEnd(Animation a) {
                if (!cancelled[0] && navDrawer.getVisibility() == View.VISIBLE) {
                    navDrawer.setVisibility(View.GONE);
                }
            }
        });
        navDrawer.startAnimation(fadeOut);
    }

    //─────────────────────────────────────────────
    // BOTÕES DE AÇÃO
    //─────────────────────────────────────────────
    private void initBotoes() {
        btnAlarme.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { abrirAlarme(); }
        });
        btnNotas.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { abrirNotas(); }
        });
        btnMusica.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { abrirMusica(); }
        });
        btnClima.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { abrirClima(); }
        });
    }

    //─────────────────────────────────────────────
    // ALARME — TimePicker + Intent AlarmClock
    //─────────────────────────────────────────────
    private void abrirAlarme() {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int horaAtual   = cal.get(java.util.Calendar.HOUR_OF_DAY);
        int minutoAtual = cal.get(java.util.Calendar.MINUTE);

        new TimePickerDialog(this,
            new TimePickerDialog.OnTimeSetListener() {
                @Override
                public void onTimeSet(TimePicker view, int hora, int minuto) {
                    try {
                        Intent intent = new Intent(AlarmClock.ACTION_SET_ALARM);
                        intent.putExtra(AlarmClock.EXTRA_HOUR, hora);
                        intent.putExtra(AlarmClock.EXTRA_MINUTES, minuto);
                        intent.putExtra(AlarmClock.EXTRA_MESSAGE, "MeuApp");
                        intent.putExtra(AlarmClock.EXTRA_SKIP_UI, false);
                        startActivity(intent);
                    } catch (Exception e) {
                        String msg = String.format(
                            Locale.getDefault(),
                            "Alarme definido para %02d:%02d", hora, minuto);
                        Toast.makeText(MainActivity.this, msg, Toast.LENGTH_LONG).show();
                    }
                }
            },
            horaAtual, minutoAtual, true
        ).show();
    }

    //─────────────────────────────────────────────
    // NOTAS — AlertDialog + SharedPreferences
    //─────────────────────────────────────────────
    private void abrirNotas() {
        final EditText editNota = new EditText(this);
        editNota.setHint(getString(R.string.notas_hint));
        editNota.setMinLines(4);
        editNota.setMaxLines(8);
        editNota.setGravity(android.view.Gravity.TOP);
        editNota.setPadding(32, 24, 32, 24);

        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String notaExistente = prefs.getString(KEY_NOTA, "");
        if (!notaExistente.isEmpty()) {
            editNota.setText(notaExistente);
            editNota.setSelection(notaExistente.length());
        }

        new AlertDialog.Builder(this)
            .setTitle(getString(R.string.notas_titulo))
            .setView(editNota)
            .setPositiveButton(getString(R.string.notas_salvar), new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    salvarNota(editNota.getText().toString().trim());
                }
            })
            .setNeutralButton(getString(R.string.notas_limpar), new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    salvarNota("");
                }
            })
            .setNegativeButton(getString(R.string.notas_cancelar), null)
            .show();
    }

    private void salvarNota(String nota) {
        getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            .edit().putString(KEY_NOTA, nota).apply();
        if (tvNotaSalva != null) {
            tvNotaSalva.setText(nota.isEmpty() ? "Nenhuma nota ainda." : nota);
        }
        Toast.makeText(this, getString(R.string.notas_salvo), Toast.LENGTH_SHORT).show();
    }

    private void carregarNotaSalva() {
        String nota = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                        .getString(KEY_NOTA, "");
        if (tvNotaSalva != null && !nota.isEmpty()) {
            tvNotaSalva.setText(nota);
        }
    }

    //─────────────────────────────────────────────
    // MÚSICA — Intent para player do sistema
    //─────────────────────────────────────────────
    private void abrirMusica() {
        try {
            Intent intent = new Intent(Intent.ACTION_MAIN);
            intent.addCategory(Intent.CATEGORY_APP_MUSIC);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        } catch (Exception e) {
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setType("audio/*");
                startActivity(intent);
            } catch (Exception e2) {
                Toast.makeText(this, "Nenhum player de música encontrado.", Toast.LENGTH_SHORT).show();
            }
        }
    }

    //─────────────────────────────────────────────
    // CLIMA — Abre previsão no navegador
    //─────────────────────────────────────────────
    private void abrirClima() {
        try {
            Uri uri = Uri.parse("https://www.google.com/search?q=previsao+do+tempo");
            startActivity(new Intent(Intent.ACTION_VIEW, uri));
        } catch (Exception e) {
            Toast.makeText(this, "Nenhum navegador encontrado.", Toast.LENGTH_SHORT).show();
        }
    }

    //─────────────────────────────────────────────
    // BOTÃO VOLTAR
    //─────────────────────────────────────────────
    @Override
    public void onBackPressed() {
        if (navDrawer.getVisibility() == View.VISIBLE) {
            closeDrawer();
        } else {
            super.onBackPressed();
        }
    }

    //─────────────────────────────────────────────
    // CICLO DE VIDA
    //─────────────────────────────────────────────
    @Override
    protected void onResume() {
        super.onResume();
        clockHandler.post(clockRunnable);
    }

    @Override
    protected void onPause() {
        super.onPause();
        clockHandler.removeCallbacks(clockRunnable);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        clockHandler.removeCallbacksAndMessages(null);
    }
}
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 6 — colors.xml
#─────────────────────────────────────────────
echo "[6/9] Criando res/values/colors.xml..."

cat > "$PROJECT/res/values/colors.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="section_top">#0A0F1E</color>
    <color name="section_bottom">#111827</color>
    <color name="toolbar_bg">#0D1B2A</color>
    <color name="drawer_bg">#0A0F1E</color>
    <color name="drawer_item_bg">#1A2540</color>
    <color name="text_light">#FFFFFF</color>
    <color name="text_light_dim">#90CAF9</color>
    <color name="text_date">#7986CB</color>
    <color name="text_status">#4CAF50</color>
    <color name="btn_alarme">#E53935</color>
    <color name="btn_notas">#43A047</color>
    <color name="btn_musica">#8E24AA</color>
    <color name="btn_clima">#00ACC1</color>
    <color name="divider">#1E2D45</color>
</resources>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 7 — strings.xml
#─────────────────────────────────────────────
echo "[7/9] Criando res/values/strings.xml..."

cat > "$PROJECT/res/values/strings.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">MeuApp</string>
    <string name="menu_desc">Abrir menu lateral</string>
    <string name="status_ativo">&#9679; Sistema ativo</string>
    <string name="close_menu_desc">Fechar menu lateral</string>
    <string name="drawer_title">Menu</string>
    <string name="notas_titulo">Minhas Notas</string>
    <string name="notas_hint">Digite sua nota aqui...</string>
    <string name="notas_salvar">Salvar</string>
    <string name="notas_cancelar">Cancelar</string>
    <string name="notas_salvo">Nota salva!</string>
    <string name="notas_limpar">Limpar</string>
    <string name="alarme_titulo">Alarme</string>
    <string name="alarme_msg">Abrindo o relógio do sistema...</string>
    <string name="clima_titulo">Clima</string>
    <string name="clima_msg">Abrindo previsão do tempo...</string>
</resources>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 8 — themes.xml
#─────────────────────────────────────────────
echo "[8/9] Criando res/values/themes.xml..."

cat > "$PROJECT/res/values/themes.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="AppTheme" parent="android:Theme.Material.NoActionBar">
        <item name="android:statusBarColor">#0A0F1E</item>
        <item name="android:navigationBarColor">#0A0F1E</item>
        <item name="android:colorAccent">#00ACC1</item>
    </style>
</resources>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 9 — install-adb.sh + resultado final
#─────────────────────────────────────────────
echo "[9/9] Criando install-adb.sh e verificando arquivos..."

cat > "$PROJECT/install-adb.sh" << 'ENDOFFILE'
#!/bin/bash
APK="./build/output/MeuApp-signed.apk"
echo ""
echo "========================================"
echo "  Instalador do APK"
echo "========================================"
echo ""
echo "[1/3] Verificando adb..."
if ! command -v adb &> /dev/null; then
    echo "      Instalando android-tools..."
    pkg update -y && pkg install android-tools -y
else
    echo "      adb OK: $(adb version | head -n 1)"
fi
echo "[2/3] Verificando APK..."
if [ ! -f "$APK" ]; then
    echo "❌ APK não encontrado. Rode: ./build.sh"
    exit 1
fi
echo "      APK encontrado."
echo ""
echo "[3/3] Como instalar?"
echo "  1) No próprio celular (termux-open)"
echo "  2) Via USB/ADB em outro dispositivo"
read -p "Opção [1-2]: " opcao
case "$opcao" in
    1) termux-open "$APK" && echo "✅ Toque em Instalar." ;;
    2) adb devices && read -p "ENTER quando pronto..." && adb install -r "$APK" && echo "✅ Instalado." ;;
    *) echo "❌ Opção inválida." && exit 1 ;;
esac
ENDOFFILE

chmod +x "$PROJECT/install-adb.sh"

echo ""
find "$PROJECT" -type f | grep -v build | sort
echo ""
echo "========================================"
echo "  Projeto criado com sucesso!"
echo "========================================"
echo ""
echo "  Próximos passos:"
echo "  cd $PROJECT"
echo "  ./build.sh"
echo "  bash install-adb.sh"
echo "========================================"
echo ""
