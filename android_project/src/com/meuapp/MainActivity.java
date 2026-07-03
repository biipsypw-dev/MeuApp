package com.meuapp;

/*=================================================
    IMPORTS
    Classes nativas Android + widgets de prática
=================================================*/
import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.SeekBar;
import android.widget.Switch;
import android.widget.TextView;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;


/**
 * =================================================
 * ACTIVITY PRINCIPAL — MainActivity.java
 *
 * Agora inclui área de prática no menu lateral com:
 *   - EditText, Button, Switch, CheckBox, SeekBar
 * =================================================
 */
public class MainActivity extends Activity {


    //─────────────────────────────────────────────
    // BLOCO 1 — DECLARAÇÃO DE VIEWS
    //─────────────────────────────────────────────

    /* Views da tela principal */
    private TextView    tvClock;
    private FrameLayout navDrawer;
    private Button      btnMenu;
    private Button      btnCloseDrawer;

    /* Views de prática no menu lateral */
    private EditText   etName;        // Campo de texto
    private Button     btnUpdate;     // Botão de ação
    private Switch     switchOption;  // Interruptor
    private CheckBox   cbOption;      // Caixa de marcação
    private SeekBar    seekSize;      // Controle deslizante
    private TextView   tvResult;      // Painel de resultado

    /* Controle do relógio */
    private Handler  clockHandler;
    private Runnable clockRunnable;

    /* Constantes */
    private static final SimpleDateFormat TIME_FORMAT =
            new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
    private static final long CLOCK_INTERVAL_MS = 1000L;
    private static final long ANIM_FADE_IN_MS  = 250L;
    private static final long ANIM_FADE_OUT_MS = 180L;


    //─────────────────────────────────────────────
    // BLOCO 2 — onCreate
    //─────────────────────────────────────────────
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initViews();
        initClock();
        initDrawer();
        initPracticeWidgets(); // <-- NOVO: liga os widgets de prática
    }


    //─────────────────────────────────────────────
    // BLOCO 3 — INICIALIZAÇÃO DE VIEWS
    //─────────────────────────────────────────────
    private void initViews() {
        tvClock        = findViewById(R.id.tv_clock);
        navDrawer      = findViewById(R.id.nav_drawer);
        btnMenu        = findViewById(R.id.btn_menu);
        btnCloseDrawer = findViewById(R.id.btn_close_drawer);
    }


    //─────────────────────────────────────────────
    // BLOCO 4 — RELÓGIO
    //─────────────────────────────────────────────
    private void initClock() {
        clockHandler = new Handler(Looper.getMainLooper());

        clockRunnable = new Runnable() {
            @Override
            public void run() {
                String horaAtual = TIME_FORMAT.format(new Date());
                tvClock.setText(horaAtual);
                clockHandler.postDelayed(this, CLOCK_INTERVAL_MS);
            }
        };
    }


    //─────────────────────────────────────────────
    // BLOCO 5 — MENU LATERAL (ABRIR/FECHAR)
    //─────────────────────────────────────────────
    private void initDrawer() {
        btnMenu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                openDrawer();
            }
        });

        btnCloseDrawer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                closeDrawer();
            }
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
            @Override public void onAnimationStart(Animation a)  { }
            @Override public void onAnimationRepeat(Animation a) { }

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
    // BLOCO 6 — WIDGETS DE PRÁTICA
    // Aqui você aprende a capturar eventos de cada objeto
    //─────────────────────────────────────────────
    private void initPracticeWidgets() {

        //── 1. Conecta as views do Java ao XML ─────
        etName       = findViewById(R.id.et_name);
        btnUpdate    = findViewById(R.id.btn_update);
        switchOption = findViewById(R.id.switch_option);
        cbOption     = findViewById(R.id.cb_option);
        seekSize     = findViewById(R.id.seek_size);
        tvResult     = findViewById(R.id.tv_result);

        //── 2. Botão "Atualizar" ────────────────────
        // Quando clicado, lê o EditText e atualiza o resultado
        btnUpdate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                updateResult();
            }
        });

        //── 3. Switch (interruptor) ─────────────────
        // Quando mudar de ligado para desligado, atualiza resultado
        switchOption.setOnCheckedChangeListener(
            new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    updateResult();
                }
            }
        );

        //── 4. CheckBox ─────────────────────────────
        // Quando marcar/desmarcar, atualiza resultado
        cbOption.setOnCheckedChangeListener(
            new CompoundButton.OnCheckedChangeListener() {
                @Override
                public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                    updateResult();
                }
            }
        );

        //── 5. SeekBar (controle deslizante) ────────
        // Quando arrastar, muda o tamanho do texto do resultado
        seekSize.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                // Mínimo 12sp para não ficar muito pequeno
                float newSize = 12 + progress;
                tvResult.setTextSize(newSize);
                updateResult();
            }

            @Override public void onStartTrackingTouch(SeekBar seekBar) { }
            @Override public void onStopTrackingTouch(SeekBar seekBar) { }
        });

        // Atualiza resultado inicial
        updateResult();
    }

    /**
     * Lê o estado de todos os widgets e monta uma mensagem.
     * Esse método é chamado toda vez que algum widget muda.
     */
    private void updateResult() {
        String nome = etName.getText().toString().trim();
        if (nome.isEmpty()) {
            nome = "Visitante";
        }

        boolean noturno = switchOption.isChecked();
        boolean lembrar = cbOption.isChecked();
        int tamanho     = seekSize.getProgress() + 12;

        String texto = "Olá, " + nome + "!\n" +
                "Modo noturno: " + (noturno ? "ligado" : "desligado") + "\n" +
                "Lembrar: " + (lembrar ? "sim" : "não") + "\n" +
                "Texto: " + tamanho + "sp";

        tvResult.setText(texto);
    }


    //─────────────────────────────────────────────
    // BLOCO 7 — BOTÃO VOLTAR
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
    // BLOCO 8 — CICLO DE VIDA
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
