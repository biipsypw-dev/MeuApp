#!/bin/bash
#=================================================
# SETUP.SH — Gerador automático do projeto Android
# Execute no Termux: bash setup.sh
# Cria toda a estrutura de pastas e arquivos.
#=================================================

# Nome da pasta raiz do projeto (altere se quiser)
PROJECT="meuapp"

echo ""
echo "========================================"
echo "  Criando projeto: $PROJECT"
echo "========================================"

#─────────────────────────────────────────────
# BLOCO 1 — CRIAÇÃO DE DIRETÓRIOS
#─────────────────────────────────────────────
echo "[1/8] Criando estrutura de diretórios..."

mkdir -p "$PROJECT/src/com/meuapp"
mkdir -p "$PROJECT/res/layout"
mkdir -p "$PROJECT/res/values"

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 2 — AndroidManifest.xml
#─────────────────────────────────────────────
echo "[2/8] Criando AndroidManifest.xml..."

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
# BLOCO 3 — activity_main.xml
#─────────────────────────────────────────────
echo "[3/8] Criando res/layout/activity_main.xml..."

cat > "$PROJECT/res/layout/activity_main.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<!--=================================================
    LAYOUT PRINCIPAL — activity_main.xml
    Estrutura em duas camadas (FrameLayout raiz):
      Camada 1: Conteúdo principal (seção superior + inferior)
      Camada 2: Menu lateral sobreposto (tela toda, oculto por padrão)
    Sem dependências externas — apenas Views nativas Android
=================================================-->
<FrameLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">


    <!--═══════════════════════════════════════════
        CAMADA 1 — CONTEÚDO PRINCIPAL
        LinearLayout vertical divide a tela em dois:
          • Seção Superior (50%): relógio
          • Seção Inferior (50%): status + botão menu
    ═══════════════════════════════════════════-->
    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical">


        <!--── SEÇÃO SUPERIOR: RELÓGIO ──────────────
            Ocupa 50% da altura via layout_weight=1
            Conteúdo centralizado com gravity center
        ─────────────────────────────────────────-->
        <FrameLayout
            android:id="@+id/section_top"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="1"
            android:background="@color/section_top">

            <!-- Texto do relógio — atualizado em MainActivity.java -->
            <TextView
                android:id="@+id/tv_clock"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_gravity="center"
                android:text="00:00:00"
                android:textSize="56sp"
                android:textColor="@color/text_light"
                android:fontFamily="monospace"
                android:letterSpacing="0.05" />

        </FrameLayout>


        <!--── SEÇÃO INFERIOR: STATUS + BOTÃO MENU ──
            Ocupa 50% da altura via layout_weight=1
            Botão de menu no canto superior esquerdo
            Mensagem de status centralizada
        ─────────────────────────────────────────-->
        <FrameLayout
            android:id="@+id/section_bottom"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="1"
            android:background="@color/section_bottom">

            <!--── Botão Abrir Menu ──────────────────
                Posicionado: topo + esquerda da seção
                Caractere ☰ (trigram) como ícone nativo
                Não requer drawable externo
            ─────────────────────────────────────-->
            <Button
                android:id="@+id/btn_menu"
                android:layout_width="56dp"
                android:layout_height="56dp"
                android:layout_gravity="top|start"
                android:layout_margin="8dp"
                android:text="&#9776;"
                android:textSize="26sp"
                android:textColor="@color/text_light"
                android:background="?android:attr/selectableItemBackgroundBorderless"
                android:contentDescription="@string/menu_desc"
                android:padding="0dp" />

            <!--── Mensagem de Status ────────────────
                Centralizada na seção inferior
            ─────────────────────────────────────-->
            <TextView
                android:id="@+id/tv_status"
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:layout_gravity="center"
                android:text="@string/status_msg"
                android:textSize="22sp"
                android:textColor="@color/text_light" />

        </FrameLayout>

    </LinearLayout>
    <!--══ FIM CAMADA 1 ═════════════════════════-->


    <!--═══════════════════════════════════════════
        CAMADA 2 — MENU LATERAL (TELA TODA)
        Sobrepõe o conteúdo principal (FrameLayout)
        Padrão: visibility="gone" (invisível)
        Ativado por: btn_menu em MainActivity.java
        Fechado por: btn_close_drawer ou botão Voltar
    ═══════════════════════════════════════════-->
    <FrameLayout
        android:id="@+id/nav_drawer"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:background="@color/drawer_bg"
        android:visibility="gone">

        <!--── Botão Fechar Menu ─────────────────────
            Mesmo posicionamento do btn_menu
            Caractere ✕ como ícone nativo
        ─────────────────────────────────────────-->
        <Button
            android:id="@+id/btn_close_drawer"
            android:layout_width="56dp"
            android:layout_height="56dp"
            android:layout_gravity="top|start"
            android:layout_margin="8dp"
            android:text="&#10005;"
            android:textSize="22sp"
            android:textColor="@color/text_light"
            android:background="?android:attr/selectableItemBackgroundBorderless"
            android:contentDescription="@string/close_menu_desc"
            android:padding="0dp" />

        <!--── Conteúdo Central do Menu ─────────────
            Título + mensagem de status
            Centralizado vertical e horizontalmente
        ─────────────────────────────────────────-->
        <LinearLayout
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_gravity="center"
            android:orientation="vertical"
            android:gravity="center">

            <!-- Título do menu -->
            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="@string/drawer_title"
                android:textSize="32sp"
                android:textColor="@color/text_light"
                android:textStyle="bold"
                android:letterSpacing="0.08" />

            <!-- Separador visual -->
            <View
                android:layout_width="120dp"
                android:layout_height="1dp"
                android:layout_marginTop="16dp"
                android:layout_marginBottom="16dp"
                android:background="@color/divider" />

            <!-- Mensagem de status do menu -->
            <TextView
                android:layout_width="wrap_content"
                android:layout_height="wrap_content"
                android:text="@string/drawer_status"
                android:textSize="18sp"
                android:textColor="@color/text_light_dim" />

        </LinearLayout>

    </FrameLayout>
    <!--══ FIM CAMADA 2 ═════════════════════════-->


</FrameLayout>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 4 — MainActivity.java
#─────────────────────────────────────────────
echo "[4/8] Criando java/com/example/MainActivity.java..."

cat > "$PROJECT/src/com/meuapp/MainActivity.java" << 'ENDOFFILE'
package com.meuapp;

/*=================================================
    IMPORTS
    Apenas classes nativas Android e Java
    Sem AppCompat, sem bibliotecas externas
=================================================*/
import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;


/**
 * =================================================
 * ACTIVITY PRINCIPAL — MainActivity.java
 *
 * Responsabilidades:
 *   1. Exibir relógio em tempo real (seção superior)
 *   2. Controlar abertura/fechamento do menu lateral
 *   3. Interceptar botão Voltar para fechar o menu
 * =================================================
 */
public class MainActivity extends Activity {


    //─────────────────────────────────────────────
    // BLOCO 1 — DECLARAÇÃO DE VARIÁVEIS
    // Componentes da interface e controles internos
    //─────────────────────────────────────────────

    /* Views do layout */
    private TextView    tvClock;         // Exibe a hora atual (seção superior)
    private FrameLayout navDrawer;       // Painel do menu lateral (camada 2)
    private Button      btnMenu;         // Abre o menu (seção inferior, canto sup. esq.)
    private Button      btnCloseDrawer;  // Fecha o menu (dentro do drawer)

    /* Controle do relógio */
    private Handler  clockHandler;   // Agenda tarefas na UI thread
    private Runnable clockRunnable;  // Tarefa que atualiza o relógio a cada segundo

    /* Constantes */
    // Formato de hora: 24h com segundos → "14:35:07"
    private static final SimpleDateFormat TIME_FORMAT =
            new SimpleDateFormat("HH:mm:ss", Locale.getDefault());

    // Intervalo entre atualizações do relógio (1 segundo)
    private static final long CLOCK_INTERVAL_MS = 1000L;

    // Duração das animações de fade do menu (milissegundos)
    private static final long ANIM_FADE_IN_MS  = 250L;
    private static final long ANIM_FADE_OUT_MS = 180L;


    //─────────────────────────────────────────────
    // BLOCO 2 — CICLO DE VIDA: onCreate
    // Ponto de entrada: infla o layout e inicializa tudo
    //─────────────────────────────────────────────
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Infla o layout definido em res/layout/activity_main.xml
        setContentView(R.layout.activity_main);

        // Inicialização em ordem: Views → Relógio → Drawer
        initViews();
        initClock();
        initDrawer();
    }


    //─────────────────────────────────────────────
    // BLOCO 3 — INICIALIZAÇÃO DE VIEWS
    // Conecta variáveis Java aos elementos do XML
    //─────────────────────────────────────────────
    private void initViews() {
        tvClock        = findViewById(R.id.tv_clock);
        navDrawer      = findViewById(R.id.nav_drawer);
        btnMenu        = findViewById(R.id.btn_menu);
        btnCloseDrawer = findViewById(R.id.btn_close_drawer);
    }


    //─────────────────────────────────────────────
    // BLOCO 4 — RELÓGIO EM TEMPO REAL
    // Handler + Runnable que atualiza o TextView
    // a cada segundo enquanto o app está em foco.
    //
    // Fluxo:
    //   onResume() → clockHandler.post() → inicia
    //   onPause()  → removeCallbacks()   → para
    //─────────────────────────────────────────────
    private void initClock() {
        // Handler vinculado à thread principal (UI thread)
        // Uso de Looper.getMainLooper() evita warning em API 30+
        clockHandler = new Handler(Looper.getMainLooper());

        clockRunnable = new Runnable() {
            @Override
            public void run() {
                // Lê a hora atual do sistema e aplica o formato HH:mm:ss
                String horaAtual = TIME_FORMAT.format(new Date());
                tvClock.setText(horaAtual);

                // Reagenda a si mesmo para daqui a 1 segundo
                clockHandler.postDelayed(this, CLOCK_INTERVAL_MS);
            }
        };
        // Nota: a execução inicia em onResume(), não aqui,
        // para evitar duplo início no fluxo onCreate → onResume
    }


    //─────────────────────────────────────────────
    // BLOCO 5 — MENU LATERAL (DRAWER)
    // Configura os listeners dos botões abrir/fechar
    //─────────────────────────────────────────────
    private void initDrawer() {

        // Botão ☰ — abre o menu (seção inferior, canto sup. esq.)
        btnMenu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openDrawer();
            }
        });

        // Botão ✕ — fecha o menu (dentro do próprio drawer)
        btnCloseDrawer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                closeDrawer();
            }
        });
    }

    /**
     * Abre o menu lateral com animação de fade-in.
     * Cancela qualquer animação em andamento antes de iniciar
     * para evitar conflito entre fade-out e fade-in simultâneos.
     */
    private void openDrawer() {
        // Cancela animação anterior (ex: fade-out interrompido)
        navDrawer.clearAnimation();
        navDrawer.setVisibility(View.VISIBLE);

        // Fade: transparente → opaco
        AlphaAnimation fadeIn = new AlphaAnimation(0f, 1f);
        fadeIn.setDuration(ANIM_FADE_IN_MS);
        fadeIn.setFillAfter(true);
        navDrawer.startAnimation(fadeIn);
    }

    /**
     * Fecha o menu lateral com animação de fade-out.
     * O GONE é aplicado somente ao fim da animação (via listener).
     * Flag local evita que listener stale aplique GONE após reabertura.
     */
    private void closeDrawer() {
        navDrawer.clearAnimation();

        // Flag local: detecta se esta animação foi substituída antes de terminar
        final boolean[] cancelled = {false};

        // Fade: opaco → transparente
        AlphaAnimation fadeOut = new AlphaAnimation(1f, 0f);
        fadeOut.setDuration(ANIM_FADE_OUT_MS);
        fadeOut.setFillAfter(true);

        fadeOut.setAnimationListener(new Animation.AnimationListener() {
            @Override public void onAnimationStart(Animation a)  { /* não usado */ }
            @Override public void onAnimationRepeat(Animation a) { /* não usado */ }

            @Override
            public void onAnimationEnd(Animation a) {
                // Aplica GONE apenas se o drawer não foi reaberto
                if (!cancelled[0] && navDrawer.getVisibility() == View.VISIBLE) {
                    navDrawer.setVisibility(View.GONE);
                }
            }
        });

        navDrawer.startAnimation(fadeOut);
    }


    //─────────────────────────────────────────────
    // BLOCO 6 — BOTÃO VOLTAR (BACK)
    // Se o menu estiver aberto, fecha-o em vez de sair do app
    //─────────────────────────────────────────────
    @Override
    public void onBackPressed() {
        if (navDrawer.getVisibility() == View.VISIBLE) {
            // Menu aberto → fecha o menu, não sai do app
            closeDrawer();
        } else {
            // Menu fechado → comportamento padrão
            super.onBackPressed();
        }
    }


    //─────────────────────────────────────────────
    // BLOCO 7 — CICLO DE VIDA: onResume / onPause
    // Gerencia o relógio conforme visibilidade do app
    //─────────────────────────────────────────────

    @Override
    protected void onResume() {
        super.onResume();
        // App voltou ao foco → inicia (ou reinicia) o relógio
        clockHandler.post(clockRunnable);
    }

    @Override
    protected void onPause() {
        super.onPause();
        // App saiu do foco → para o relógio para economizar recursos
        clockHandler.removeCallbacks(clockRunnable);
    }


    //─────────────────────────────────────────────
    // BLOCO 8 — CICLO DE VIDA: onDestroy
    // Limpeza final: remove todos os callbacks pendentes
    //─────────────────────────────────────────────
    @Override
    protected void onDestroy() {
        super.onDestroy();
        clockHandler.removeCallbacksAndMessages(null);
    }

}
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 5 — colors.xml
#─────────────────────────────────────────────
echo "[5/8] Criando res/values/colors.xml..."

cat > "$PROJECT/res/values/colors.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<!--=================================================
    RECURSOS DE COR — colors.xml
    Paleta centralizada do aplicativo.
    Altere aqui para mudar as cores em todo o app.
    Paleta atual: Azul Índigo escuro
=================================================-->
<resources>

    <!--── SEÇÃO SUPERIOR (Relógio) ─────────────────-->
    <color name="section_top">#1A237E</color>

    <!--── SEÇÃO INFERIOR (Status + Menu) ───────────-->
    <color name="section_bottom">#283593</color>

    <!--── MENU LATERAL (Drawer) ────────────────────-->
    <color name="drawer_bg">#0D1B6B</color>

    <!--── TEXTOS ───────────────────────────────────-->
    <color name="text_light">#FFFFFF</color>
    <color name="text_light_dim">#90CAF9</color>

    <!--── DIVISOR ──────────────────────────────────-->
    <color name="divider">#3949AB</color>

</resources>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 6 — strings.xml
#─────────────────────────────────────────────
echo "[6/8] Criando res/values/strings.xml..."

cat > "$PROJECT/res/values/strings.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<!--=================================================
    RECURSOS DE TEXTO — strings.xml
    Centraliza todas as strings visíveis no app.
    Edite aqui para alterar textos sem tocar no Java.
=================================================-->
<resources>

    <!--── NOME DO APP ───────────────────────────────-->
    <string name="app_name">MeuApp</string>

    <!--── SEÇÃO INFERIOR ───────────────────────────-->
    <string name="status_msg">&#10004; Funcionando</string>
    <string name="menu_desc">Abrir menu lateral</string>

    <!--── MENU LATERAL (DRAWER) ────────────────────-->
    <string name="drawer_title">Menu</string>
    <string name="drawer_status">Sistema funcionando</string>
    <string name="close_menu_desc">Fechar menu lateral</string>

</resources>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 7 — themes.xml
#─────────────────────────────────────────────
echo "[7/8] Criando res/values/themes.xml..."

cat > "$PROJECT/res/values/themes.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<!--=================================================
    TEMA DO APP — themes.xml
    Usa android:Theme.Material nativo (API 21+)
    SEM AppCompat — compatível com pipeline ECJ/D8

    Por que NoActionBar:
      Layout usa tela cheia com seções manuais.
      A ActionBar padrão ocuparia espaço desnecessário.
=================================================-->
<resources>

    <!--── TEMA PRINCIPAL ───────────────────────────
        parent: android:Theme.Material.NoActionBar
          → Tema Material nativo do Android
          → Sem barra de título (ActionBar)
          → Sem dependência de AppCompat
          → Compatível com API 21+ (target API 34)
    ─────────────────────────────────────────────-->
    <style name="AppTheme" parent="android:Theme.Material.NoActionBar">

        <!-- Cor da status bar (barra de notificações no topo) -->
        <item name="android:statusBarColor">#1A237E</item>

        <!-- Cor da navigation bar (barra de botões na base) -->
        <item name="android:navigationBarColor">#1A237E</item>

        <!-- Cor de destaque para widgets interativos -->
        <item name="android:colorAccent">#5C6BC0</item>

    </style>

</resources>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 8 — RESULTADO FINAL
#─────────────────────────────────────────────
echo "[8/8] Verificando arquivos criados..."
echo ""

find "$PROJECT" -type f | sort

echo ""
echo "========================================"
echo "  Projeto criado com sucesso!"
echo "  Pasta: $(pwd)/$PROJECT"
echo "========================================"
echo ""
echo "  Próximo passo: copie os arquivos para"
echo "  dentro do seu projeto e rode o build.sh"
echo "========================================"
echo ""
