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
