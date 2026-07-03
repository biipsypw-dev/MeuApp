#!/bin/bash
#=================================================
# SETUP.SH — Gerador automático do projeto Android
# Execute no Termux: bash setup.sh
# Cria toda a estrutura de pastas e arquivos.
# Versão com painel de conteúdo e menu com slide.
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
            android:windowSoftInputMode="adjustResize">

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
# BLOCO 3 — DRAWABLES
#─────────────────────────────────────────────
echo "[3/9] Criando res/drawable/..."

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

# Botão neutro — usado nos "Fechar", "Limpar", "Voltar"
cat > "$PROJECT/res/drawable/btn_neutral.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:state_pressed="true">
        <shape android:shape="rectangle">
            <solid android:color="#2D4060"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
    <item>
        <shape android:shape="rectangle">
            <solid android:color="#1A2540"/>
            <corners android:radius="16dp"/>
        </shape>
    </item>
</selector>
ENDOFFILE

# Fundo do EditText de notas
cat > "$PROJECT/res/drawable/bg_edittext.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android"
    android:shape="rectangle">
    <solid android:color="#111827"/>
    <stroke android:width="1dp" android:color="#2D4060"/>
    <corners android:radius="10dp"/>
</shape>
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

    Estrutura (3 camadas no FrameLayout raiz):
      CAMADA 1 — Conteúdo principal
        ├─ Seção superior (40%): 5 painéis (um visível por vez)
        │    ├─ panel_relogio  — padrão: relógio + data
        │    ├─ panel_notas   — editor de notas inline
        │    ├─ panel_alarme  — botão para definir alarme
        │    ├─ panel_musica  — botão para abrir player
        │    └─ panel_clima   — botão para abrir previsão
        └─ Seção inferior (60%): Toolbar + Botões 2×2
      CAMADA 2 — Overlay escuro (fecha menu ao tocar)
      CAMADA 3 — Menu lateral deslizante (250dp, slide da esquerda)
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


        <!--── SEÇÃO SUPERIOR: PAINÉIS DE CONTEÚDO ───-->
        <!--  Todos os painéis vivem aqui sobrepostos.   -->
        <!--  Apenas um fica VISIBLE por vez (via Java). -->
        <FrameLayout
            android:id="@+id/section_top"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="4"
            android:background="@color/section_top">


            <!--┄┄ PAINEL 1: RELÓGIO (padrão) ┄┄┄┄┄┄-->
            <LinearLayout
                android:id="@+id/panel_relogio"
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:orientation="vertical"
                android:gravity="center"
                android:visibility="visible">

                <TextView
                    android:id="@+id/tv_clock"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="00:00:00"
                    android:textSize="64sp"
                    android:textColor="@color/text_light"
                    android:fontFamily="monospace"
                    android:letterSpacing="0.05" />

                <TextView
                    android:id="@+id/tv_date"
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="6dp"
                    android:text="Seg, 01 Jan 2025"
                    android:textSize="16sp"
                    android:textColor="@color/text_date"
                    android:letterSpacing="0.08" />

            </LinearLayout>
            <!--┄┄ FIM PAINEL 1 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->


            <!--┄┄ PAINEL 2: NOTAS ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->
            <LinearLayout
                android:id="@+id/panel_notas"
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:orientation="vertical"
                android:padding="20dp"
                android:visibility="gone">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="&#128221; Notas"
                    android:textSize="18sp"
                    android:textStyle="bold"
                    android:textColor="@color/text_light"
                    android:layout_marginBottom="12dp" />

                <EditText
                    android:id="@+id/et_nota"
                    android:layout_width="match_parent"
                    android:layout_height="0dp"
                    android:layout_weight="1"
                    android:hint="@string/notas_hint"
                    android:textColor="@color/text_light"
                    android:textColorHint="@color/text_date"
                    android:background="@drawable/bg_edittext"
                    android:padding="12dp"
                    android:gravity="top"
                    android:inputType="textMultiLine|textCapSentences"
                    android:textSize="15sp" />

                <LinearLayout
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:orientation="horizontal"
                    android:layout_marginTop="10dp">

                    <Button
                        android:id="@+id/btn_nota_salvar"
                        android:layout_width="0dp"
                        android:layout_height="40dp"
                        android:layout_weight="1"
                        android:layout_marginEnd="6dp"
                        android:text="@string/notas_salvar"
                        android:textColor="@color/text_light"
                        android:textSize="13sp"
                        android:background="@drawable/btn_notas" />

                    <Button
                        android:id="@+id/btn_nota_limpar"
                        android:layout_width="0dp"
                        android:layout_height="40dp"
                        android:layout_weight="1"
                        android:layout_marginEnd="6dp"
                        android:text="@string/notas_limpar"
                        android:textColor="@color/text_light"
                        android:textSize="13sp"
                        android:background="@drawable/btn_neutral" />

                    <Button
                        android:id="@+id/btn_nota_fechar"
                        android:layout_width="0dp"
                        android:layout_height="40dp"
                        android:layout_weight="1"
                        android:text="&#10005;"
                        android:textColor="@color/text_light"
                        android:textSize="16sp"
                        android:background="@drawable/btn_neutral" />

                </LinearLayout>

            </LinearLayout>
            <!--┄┄ FIM PAINEL 2 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->


            <!--┄┄ PAINEL 3: ALARME ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->
            <LinearLayout
                android:id="@+id/panel_alarme"
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:orientation="vertical"
                android:gravity="center"
                android:padding="24dp"
                android:visibility="gone">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="&#9200; Alarme"
                    android:textSize="22sp"
                    android:textStyle="bold"
                    android:textColor="@color/text_light" />

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="8dp"
                    android:layout_marginBottom="20dp"
                    android:text="Defina um horario para ser lembrado."
                    android:textSize="13sp"
                    android:textColor="@color/text_date"
                    android:gravity="center" />

                <Button
                    android:id="@+id/btn_definir_alarme"
                    android:layout_width="200dp"
                    android:layout_height="48dp"
                    android:text="Escolher Horario"
                    android:textColor="@color/text_light"
                    android:textSize="14sp"
                    android:background="@drawable/btn_alarme" />

                <Button
                    android:id="@+id/btn_alarme_fechar"
                    android:layout_width="200dp"
                    android:layout_height="40dp"
                    android:layout_marginTop="10dp"
                    android:text="Fechar"
                    android:textColor="@color/text_light"
                    android:textSize="13sp"
                    android:background="@drawable/btn_neutral" />

            </LinearLayout>
            <!--┄┄ FIM PAINEL 3 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->


            <!--┄┄ PAINEL 4: MÚSICA ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->
            <LinearLayout
                android:id="@+id/panel_musica"
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:orientation="vertical"
                android:gravity="center"
                android:padding="24dp"
                android:visibility="gone">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="&#127925; Musica"
                    android:textSize="22sp"
                    android:textStyle="bold"
                    android:textColor="@color/text_light" />

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="8dp"
                    android:layout_marginBottom="20dp"
                    android:text="Abre o reprodutor padrao do dispositivo."
                    android:textSize="13sp"
                    android:textColor="@color/text_date"
                    android:gravity="center" />

                <Button
                    android:id="@+id/btn_abrir_musica"
                    android:layout_width="200dp"
                    android:layout_height="48dp"
                    android:text="Abrir Player"
                    android:textColor="@color/text_light"
                    android:textSize="14sp"
                    android:background="@drawable/btn_musica" />

                <Button
                    android:id="@+id/btn_musica_fechar"
                    android:layout_width="200dp"
                    android:layout_height="40dp"
                    android:layout_marginTop="10dp"
                    android:text="Fechar"
                    android:textColor="@color/text_light"
                    android:textSize="13sp"
                    android:background="@drawable/btn_neutral" />

            </LinearLayout>
            <!--┄┄ FIM PAINEL 4 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->


            <!--┄┄ PAINEL 5: CLIMA ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->
            <LinearLayout
                android:id="@+id/panel_clima"
                android:layout_width="match_parent"
                android:layout_height="match_parent"
                android:orientation="vertical"
                android:gravity="center"
                android:padding="24dp"
                android:visibility="gone">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="&#127780; Clima"
                    android:textSize="22sp"
                    android:textStyle="bold"
                    android:textColor="@color/text_light" />

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="8dp"
                    android:layout_marginBottom="20dp"
                    android:text="Consulta a previsao do tempo no navegador."
                    android:textSize="13sp"
                    android:textColor="@color/text_date"
                    android:gravity="center" />

                <Button
                    android:id="@+id/btn_abrir_clima"
                    android:layout_width="200dp"
                    android:layout_height="48dp"
                    android:text="Ver Previsao"
                    android:textColor="@color/text_light"
                    android:textSize="14sp"
                    android:background="@drawable/btn_clima" />

                <Button
                    android:id="@+id/btn_clima_fechar"
                    android:layout_width="200dp"
                    android:layout_height="40dp"
                    android:layout_marginTop="10dp"
                    android:text="Fechar"
                    android:textColor="@color/text_light"
                    android:textSize="13sp"
                    android:background="@drawable/btn_neutral" />

            </LinearLayout>
            <!--┄┄ FIM PAINEL 5 ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄-->


        </FrameLayout>
        <!--── FIM SEÇÃO SUPERIOR ────────────────────-->


        <!--── SEÇÃO INFERIOR: TOOLBAR + BOTÕES ─────-->
        <LinearLayout
            android:id="@+id/section_bottom"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="6"
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


            <!--── GRADE DE BOTÕES 2×2 ────────────────-->
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
                        android:text="&#127925;&#10;Musica"
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
        CAMADA 2 — OVERLAY (fecha o menu ao tocar)
        Aparece entre o conteúdo e o drawer.
    ═══════════════════════════════════════════-->
    <View
        android:id="@+id/overlay"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:background="#80000000"
        android:visibility="gone"
        android:clickable="true"
        android:focusable="true" />
    <!--══ FIM CAMADA 2 ═════════════════════════-->


    <!--═══════════════════════════════════════════
        CAMADA 3 — MENU LATERAL DESLIZANTE
        Começa fora da tela (translationX = -250dp).
        O Java anima até translationX = 0 ao abrir.
    ═══════════════════════════════════════════-->
    <LinearLayout
        android:id="@+id/nav_drawer"
        android:layout_width="250dp"
        android:layout_height="match_parent"
        android:orientation="vertical"
        android:background="@color/drawer_bg"
        android:visibility="gone"
        android:elevation="8dp">

        <!-- Cabeçalho do menu: botão X + título -->
        <LinearLayout
            android:layout_width="match_parent"
            android:layout_height="64dp"
            android:orientation="horizontal"
            android:gravity="center_vertical"
            android:paddingStart="4dp"
            android:paddingEnd="12dp">

            <Button
                android:id="@+id/btn_close_drawer"
                android:layout_width="48dp"
                android:layout_height="48dp"
                android:text="&#10005;"
                android:textSize="20sp"
                android:textColor="@color/text_light"
                android:background="?android:attr/selectableItemBackgroundBorderless"
                android:contentDescription="@string/close_menu_desc"
                android:padding="0dp" />

            <TextView
                android:layout_width="0dp"
                android:layout_height="wrap_content"
                android:layout_weight="1"
                android:layout_marginStart="8dp"
                android:text="@string/drawer_title"
                android:textSize="20sp"
                android:textStyle="bold"
                android:textColor="@color/text_light" />

        </LinearLayout>

        <!-- Divisor abaixo do cabeçalho -->
        <View
            android:layout_width="match_parent"
            android:layout_height="1dp"
            android:background="@color/divider" />

        <!-- Conteúdo rolável do menu -->
        <ScrollView
            android:layout_width="match_parent"
            android:layout_height="match_parent">

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:paddingBottom="24dp">

                <!-- Legenda "Em breve" -->
                <TextView
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="Em breve..."
                    android:textSize="11sp"
                    android:textColor="@color/text_date"
                    android:paddingStart="20dp"
                    android:paddingTop="16dp"
                    android:paddingBottom="10dp"
                    android:letterSpacing="0.1" />

                <!-- Item: Configurações -->
                <TextView
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="&#9881;  Configuracoes"
                    android:textSize="15sp"
                    android:textColor="@color/text_light_dim"
                    android:paddingStart="20dp"
                    android:paddingTop="14dp"
                    android:paddingBottom="14dp" />

                <View android:layout_width="match_parent" android:layout_height="1dp" android:background="@color/divider" />

                <!-- Item: Notificações -->
                <TextView
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="&#128276;  Notificacoes"
                    android:textSize="15sp"
                    android:textColor="@color/text_light_dim"
                    android:paddingStart="20dp"
                    android:paddingTop="14dp"
                    android:paddingBottom="14dp" />

                <View android:layout_width="match_parent" android:layout_height="1dp" android:background="@color/divider" />

                <!-- Item: Estatísticas -->
                <TextView
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="&#128202;  Estatisticas"
                    android:textSize="15sp"
                    android:textColor="@color/text_light_dim"
                    android:paddingStart="20dp"
                    android:paddingTop="14dp"
                    android:paddingBottom="14dp" />

                <View android:layout_width="match_parent" android:layout_height="1dp" android:background="@color/divider" />

                <!-- Item: Personalizar -->
                <TextView
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="&#127912;  Personalizar"
                    android:textSize="15sp"
                    android:textColor="@color/text_light_dim"
                    android:paddingStart="20dp"
                    android:paddingTop="14dp"
                    android:paddingBottom="14dp" />

                <View android:layout_width="match_parent" android:layout_height="1dp" android:background="@color/divider" />

                <!-- Item: Sobre -->
                <TextView
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="&#9432;  Sobre o App"
                    android:textSize="15sp"
                    android:textColor="@color/text_light_dim"
                    android:paddingStart="20dp"
                    android:paddingTop="14dp"
                    android:paddingBottom="14dp" />

                <View android:layout_width="match_parent" android:layout_height="1dp" android:background="@color/divider" />

                <!-- Versão no rodapé -->
                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="Versao 1.0"
                    android:textColor="@color/divider"
                    android:textSize="11sp"
                    android:paddingStart="20dp"
                    android:paddingTop="24dp" />

            </LinearLayout>
        </ScrollView>

    </LinearLayout>
    <!--══ FIM CAMADA 3 ═════════════════════════-->


</FrameLayout>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 5 — MainActivity.java
#─────────────────────────────────────────────
echo "[5/9] Criando src/com/meuapp/MainActivity.java..."

cat > "$PROJECT/src/com/meuapp/MainActivity.java" << 'ENDOFFILE'
package com.meuapp;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.ObjectAnimator;
import android.app.Activity;
import android.app.TimePickerDialog;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.provider.AlarmClock;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.TimePicker;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class MainActivity extends Activity {

    //── Seção superior: painéis ─────────────────
    private LinearLayout panelRelogio;
    private LinearLayout panelNotas;
    private LinearLayout panelAlarme;
    private LinearLayout panelMusica;
    private LinearLayout panelClima;

    //── Views do relógio ─────────────────────────
    private TextView tvClock;
    private TextView tvDate;

    //── Views do painel de notas ─────────────────
    private EditText etNota;
    private Button   btnNotaSalvar;
    private Button   btnNotaLimpar;
    private Button   btnNotaFechar;

    //── Views do painel de alarme ─────────────────
    private Button btnDefinirAlarme;
    private Button btnAlarmeFechar;

    //── Views do painel de música ─────────────────
    private Button btnAbrirMusica;
    private Button btnMusicaFechar;

    //── Views do painel de clima ──────────────────
    private Button btnAbrirClima;
    private Button btnClimaFechar;

    //── Menu lateral (drawer) ────────────────────
    private LinearLayout navDrawer;
    private Button       btnMenu;
    private Button       btnCloseDrawer;
    private View         overlay;

    //── Botões de ação (grade 2×2) ───────────────
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

    //── Constantes ───────────────────────────────
    private static final long CLOCK_INTERVAL_MS = 1000L;
    private static final int  DRAWER_ANIM_MS    = 260;
    private static final int  DRAWER_WIDTH_DP   = 250;

    private int drawerWidthPx; // 250dp em pixels físicos

    //── Preferências ─────────────────────────────
    private static final String PREFS_NAME = "meuapp_prefs";
    private static final String KEY_NOTA   = "ultima_nota";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // Converte 250dp → pixels para a animação do drawer
        drawerWidthPx = (int)(DRAWER_WIDTH_DP * getResources().getDisplayMetrics().density);

        initViews();
        initClock();
        initDrawer();
        initBotoes();
    }

    //─────────────────────────────────────────────
    // VIEWS
    //─────────────────────────────────────────────
    private void initViews() {
        // Painéis da seção superior
        panelRelogio = (LinearLayout) findViewById(R.id.panel_relogio);
        panelNotas   = (LinearLayout) findViewById(R.id.panel_notas);
        panelAlarme  = (LinearLayout) findViewById(R.id.panel_alarme);
        panelMusica  = (LinearLayout) findViewById(R.id.panel_musica);
        panelClima   = (LinearLayout) findViewById(R.id.panel_clima);

        // Relógio
        tvClock = (TextView) findViewById(R.id.tv_clock);
        tvDate  = (TextView) findViewById(R.id.tv_date);

        // Painel Notas
        etNota        = (EditText) findViewById(R.id.et_nota);
        btnNotaSalvar = (Button)   findViewById(R.id.btn_nota_salvar);
        btnNotaLimpar = (Button)   findViewById(R.id.btn_nota_limpar);
        btnNotaFechar = (Button)   findViewById(R.id.btn_nota_fechar);

        // Painel Alarme
        btnDefinirAlarme = (Button) findViewById(R.id.btn_definir_alarme);
        btnAlarmeFechar  = (Button) findViewById(R.id.btn_alarme_fechar);

        // Painel Música
        btnAbrirMusica  = (Button) findViewById(R.id.btn_abrir_musica);
        btnMusicaFechar = (Button) findViewById(R.id.btn_musica_fechar);

        // Painel Clima
        btnAbrirClima  = (Button) findViewById(R.id.btn_abrir_clima);
        btnClimaFechar = (Button) findViewById(R.id.btn_clima_fechar);

        // Menu lateral
        navDrawer      = (LinearLayout) findViewById(R.id.nav_drawer);
        btnMenu        = (Button)       findViewById(R.id.btn_menu);
        btnCloseDrawer = (Button)       findViewById(R.id.btn_close_drawer);
        overlay        = (View)         findViewById(R.id.overlay);

        // Botões de ação (grade)
        btnAlarme = (Button) findViewById(R.id.btn_alarme);
        btnNotas  = (Button) findViewById(R.id.btn_notas);
        btnMusica = (Button) findViewById(R.id.btn_musica);
        btnClima  = (Button) findViewById(R.id.btn_clima);
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
    // MENU LATERAL — abertura e fechamento
    //─────────────────────────────────────────────
    private void initDrawer() {
        btnMenu.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { openDrawer(); }
        });
        btnCloseDrawer.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { closeDrawer(); }
        });
        overlay.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { closeDrawer(); }
        });
    }

    /**
     * Abre o menu lateral com animação de slide da esquerda.
     * 1. Define a posição inicial fora da tela (translationX negativo).
     * 2. Torna o drawer e o overlay visíveis.
     * 3. Anima translationX de -drawerWidthPx até 0 em 260ms.
     */
    private void openDrawer() {
        navDrawer.setTranslationX(-drawerWidthPx);
        navDrawer.setVisibility(View.VISIBLE);
        overlay.setVisibility(View.VISIBLE);

        ObjectAnimator anim = ObjectAnimator.ofFloat(
                navDrawer, "translationX", -drawerWidthPx, 0f);
        anim.setDuration(DRAWER_ANIM_MS);
        anim.start();
    }

    /**
     * Fecha o menu lateral com animação de slide para a esquerda.
     * Ao fim da animação, o drawer e o overlay ficam GONE.
     */
    private void closeDrawer() {
        ObjectAnimator anim = ObjectAnimator.ofFloat(
                navDrawer, "translationX", 0f, -drawerWidthPx);
        anim.setDuration(DRAWER_ANIM_MS);
        anim.addListener(new AnimatorListenerAdapter() {
            @Override
            public void onAnimationEnd(Animator animation) {
                navDrawer.setVisibility(View.GONE);
                overlay.setVisibility(View.GONE);
            }
        });
        anim.start();
    }

    //─────────────────────────────────────────────
    // TROCA DE PAINÉIS — seção superior
    //─────────────────────────────────────────────

    /**
     * Esconde todos os painéis e exibe somente o solicitado.
     * Simples: sem animação entre painéis (pode ser adicionado depois).
     */
    private void mostrarPanel(LinearLayout painel) {
        panelRelogio.setVisibility(View.GONE);
        panelNotas.setVisibility(View.GONE);
        panelAlarme.setVisibility(View.GONE);
        panelMusica.setVisibility(View.GONE);
        panelClima.setVisibility(View.GONE);
        painel.setVisibility(View.VISIBLE);
    }

    //─────────────────────────────────────────────
    // BOTÕES DE AÇÃO + BOTÕES DOS PAINÉIS
    //─────────────────────────────────────────────
    private void initBotoes() {

        // ── Grade 2×2: abre o painel correspondente ──
        btnAlarme.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { mostrarPanel(panelAlarme); }
        });
        btnNotas.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { abrirPainelNotas(); }
        });
        btnMusica.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { mostrarPanel(panelMusica); }
        });
        btnClima.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { mostrarPanel(panelClima); }
        });

        // ── Painel Notas ──────────────────────────────
        btnNotaSalvar.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { salvarNota(); }
        });
        btnNotaLimpar.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { etNota.setText(""); }
        });
        btnNotaFechar.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { mostrarPanel(panelRelogio); }
        });

        // ── Painel Alarme ─────────────────────────────
        btnDefinirAlarme.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { abrirTimePicker(); }
        });
        btnAlarmeFechar.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { mostrarPanel(panelRelogio); }
        });

        // ── Painel Música ─────────────────────────────
        btnAbrirMusica.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { lancarPlayer(); }
        });
        btnMusicaFechar.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { mostrarPanel(panelRelogio); }
        });

        // ── Painel Clima ──────────────────────────────
        btnAbrirClima.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { abrirNavegadorClima(); }
        });
        btnClimaFechar.setOnClickListener(new View.OnClickListener() {
            @Override public void onClick(View v) { mostrarPanel(panelRelogio); }
        });
    }

    //─────────────────────────────────────────────
    // NOTAS — painel inline
    //─────────────────────────────────────────────
    private void abrirPainelNotas() {
        // Carrega nota salva no EditText antes de mostrar o painel
        String notaSalva = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .getString(KEY_NOTA, "");
        etNota.setText(notaSalva);
        if (!notaSalva.isEmpty()) {
            etNota.setSelection(notaSalva.length());
        }
        mostrarPanel(panelNotas);
    }

    private void salvarNota() {
        String nota = etNota.getText().toString().trim();
        getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
                .edit().putString(KEY_NOTA, nota).apply();
        Toast.makeText(this, getString(R.string.notas_salvo), Toast.LENGTH_SHORT).show();
        mostrarPanel(panelRelogio);
    }

    //─────────────────────────────────────────────
    // ALARME — TimePicker abre sobre o painel
    //─────────────────────────────────────────────
    private void abrirTimePicker() {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int hora   = cal.get(java.util.Calendar.HOUR_OF_DAY);
        int minuto = cal.get(java.util.Calendar.MINUTE);

        new TimePickerDialog(this,
            new TimePickerDialog.OnTimeSetListener() {
                @Override
                public void onTimeSet(TimePicker view, int h, int m) {
                    try {
                        Intent intent = new Intent(AlarmClock.ACTION_SET_ALARM);
                        intent.putExtra(AlarmClock.EXTRA_HOUR, h);
                        intent.putExtra(AlarmClock.EXTRA_MINUTES, m);
                        intent.putExtra(AlarmClock.EXTRA_MESSAGE, "MeuApp");
                        intent.putExtra(AlarmClock.EXTRA_SKIP_UI, false);
                        startActivity(intent);
                    } catch (Exception e) {
                        String msg = String.format(Locale.getDefault(),
                                "Alarme definido para %02d:%02d", h, m);
                        Toast.makeText(MainActivity.this, msg, Toast.LENGTH_LONG).show();
                    }
                }
            },
            hora, minuto, true
        ).show();
    }

    //─────────────────────────────────────────────
    // MÚSICA — Intent para player do sistema
    //─────────────────────────────────────────────
    private void lancarPlayer() {
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
                Toast.makeText(this,
                        "Nenhum player de musica encontrado.",
                        Toast.LENGTH_SHORT).show();
            }
        }
    }

    //─────────────────────────────────────────────
    // CLIMA — Abre previsão no navegador
    //─────────────────────────────────────────────
    private void abrirNavegadorClima() {
        try {
            Uri uri = Uri.parse("https://www.google.com/search?q=previsao+do+tempo");
            startActivity(new Intent(Intent.ACTION_VIEW, uri));
        } catch (Exception e) {
            Toast.makeText(this,
                    "Nenhum navegador encontrado.",
                    Toast.LENGTH_SHORT).show();
        }
    }

    //─────────────────────────────────────────────
    // BOTÃO VOLTAR
    //─────────────────────────────────────────────
    @Override
    public void onBackPressed() {
        if (navDrawer.getVisibility() == View.VISIBLE) {
            closeDrawer();
        } else if (panelRelogio.getVisibility() != View.VISIBLE) {
            // Qualquer painel aberto → volta pro relógio
            mostrarPanel(panelRelogio);
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
    <string name="notas_hint">Digite sua nota aqui...</string>
    <string name="notas_salvar">Salvar</string>
    <string name="notas_cancelar">Cancelar</string>
    <string name="notas_salvo">Nota salva!</string>
    <string name="notas_limpar">Limpar</string>
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
    echo "APK nao encontrado. Rode: ./build.sh"
    exit 1
fi
echo "      APK encontrado."
echo ""
echo "[3/3] Como instalar?"
echo "  1) No proprio celular (termux-open)"
echo "  2) Via USB/ADB em outro dispositivo"
read -p "Opcao [1-2]: " opcao
case "$opcao" in
    1) termux-open "$APK" && echo "Toque em Instalar." ;;
    2) adb devices && read -p "ENTER quando pronto..." && adb install -r "$APK" && echo "Instalado." ;;
    *) echo "Opcao invalida." && exit 1 ;;
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
echo "  Proximos passos:"
echo "  cd $PROJECT"
echo "  ./build.sh"
echo "  bash install-adb.sh"
echo "========================================"
echo ""
