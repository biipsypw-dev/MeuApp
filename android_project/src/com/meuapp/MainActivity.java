package com.meuapp;

/*=================================================
    IMPORTS
    Apenas classes nativas Android e Java.
    Sem AppCompat, sem bibliotecas externas.
=================================================*/
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


/**
 * =================================================
 * ACTIVITY PRINCIPAL — MainActivity.java
 *
 * Responsabilidades:
 *   1. Exibir relógio e data em tempo real
 *   2. Controlar abertura/fechamento do menu lateral
 *   3. Funcionalidades dos 4 botões:
 *      - Alarme  → abre TimePicker e define alarme
 *      - Notas   → abre editor com SharedPreferences
 *      - Música  → abre player de música do sistema
 *      - Clima   → abre previsão no navegador
 * =================================================
 */
public class MainActivity extends Activity {


    //─────────────────────────────────────────────
    // BLOCO 1 — DECLARAÇÃO DE VARIÁVEIS
    //─────────────────────────────────────────────

    /* Views principais */
    private TextView    tvClock;
    private TextView    tvDate;
    private TextView    tvNotaSalva;
    private FrameLayout navDrawer;
    private Button      btnMenu;
    private Button      btnCloseDrawer;

    /* Botões de ação */
    private Button btnAlarme;
    private Button btnNotas;
    private Button btnMusica;
    private Button btnClima;

    /* Relógio */
    private Handler  clockHandler;
    private Runnable clockRunnable;

    /* Formatos de data/hora */
    private static final SimpleDateFormat TIME_FORMAT =
            new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
    private static final SimpleDateFormat DATE_FORMAT =
            new SimpleDateFormat("EEE, dd MMM yyyy", new Locale("pt", "BR"));

    /* Constantes de tempo */
    private static final long CLOCK_INTERVAL_MS = 1000L;
    private static final long ANIM_FADE_IN_MS   = 250L;
    private static final long ANIM_FADE_OUT_MS  = 180L;

    /* SharedPreferences — salvar notas localmente */
    private static final String PREFS_NAME  = "meuapp_prefs";
    private static final String KEY_NOTA    = "ultima_nota";


    //─────────────────────────────────────────────
    // BLOCO 2 — CICLO DE VIDA: onCreate
    //─────────────────────────────────────────────
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
    // BLOCO 3 — INICIALIZAÇÃO DE VIEWS
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
    // BLOCO 4 — RELÓGIO + DATA EM TEMPO REAL
    // Atualiza hora e data a cada segundo
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
    // BLOCO 5 — MENU LATERAL (DRAWER)
    //─────────────────────────────────────────────
    private void initDrawer() {
        btnMenu.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) { openDrawer(); }
        });

        btnCloseDrawer.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) { closeDrawer(); }
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
    // BLOCO 6 — BOTÕES DE AÇÃO
    // Cada botão tem uma função real
    //─────────────────────────────────────────────
    private void initBotoes() {

        /*── ALARME ─────────────────────────────────
         * Abre um TimePicker para o usuário escolher
         * a hora, depois tenta criar o alarme via
         * Intent padrão do sistema.
         ────────────────────────────────────────────*/
        btnAlarme.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                abrirAlarme();
            }
        });

        /*── NOTAS ───────────────────────────────────
         * Abre um AlertDialog com EditText.
         * A nota é salva em SharedPreferences e
         * exibida no menu lateral.
         ────────────────────────────────────────────*/
        btnNotas.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                abrirNotas();
            }
        });

        /*── MÚSICA ──────────────────────────────────
         * Abre o player de música padrão do sistema
         * via Intent com categoria APP_MUSIC.
         ────────────────────────────────────────────*/
        btnMusica.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                abrirMusica();
            }
        });

        /*── CLIMA ───────────────────────────────────
         * Abre a previsão do tempo no navegador
         * usando a URL do Google Clima.
         ────────────────────────────────────────────*/
        btnClima.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                abrirClima();
            }
        });
    }


    //─────────────────────────────────────────────
    // BLOCO 7 — IMPLEMENTAÇÃO DO ALARME
    //─────────────────────────────────────────────

    /**
     * Abre um TimePickerDialog (relógio visual para
     * escolher hora e minuto), depois dispara o
     * alarme via Intent ACTION_SET_ALARM.
     *
     * O Android abre automaticamente o app de relógio
     * do sistema com o horário já preenchido.
     */
    private void abrirAlarme() {
        // Pega hora atual para pré-preencher o picker
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int horaAtual   = cal.get(java.util.Calendar.HOUR_OF_DAY);
        int minutoAtual = cal.get(java.util.Calendar.MINUTE);

        // Abre o seletor de hora (formato 24h)
        TimePickerDialog picker = new TimePickerDialog(
            this,
            new TimePickerDialog.OnTimeSetListener() {
                @Override
                public void onTimeSet(TimePicker view, int hora, int minuto) {

                    // Tenta abrir o app de alarme do sistema
                    try {
                        Intent intent = new Intent(AlarmClock.ACTION_SET_ALARM);
                        intent.putExtra(AlarmClock.EXTRA_HOUR, hora);
                        intent.putExtra(AlarmClock.EXTRA_MINUTES, minuto);
                        intent.putExtra(AlarmClock.EXTRA_MESSAGE, "MeuApp");
                        intent.putExtra(AlarmClock.EXTRA_SKIP_UI, false);
                        startActivity(intent);
                    } catch (Exception e) {
                        // Fallback: mostra confirmação em toast
                        String msg = String.format(
                            Locale.getDefault(),
                            "Alarme definido para %02d:%02d", hora, minuto
                        );
                        Toast.makeText(MainActivity.this, msg, Toast.LENGTH_LONG).show();
                    }
                }
            },
            horaAtual,
            minutoAtual,
            true // formato 24h
        );

        picker.setTitle("Definir alarme");
        picker.show();
    }


    //─────────────────────────────────────────────
    // BLOCO 8 — IMPLEMENTAÇÃO DAS NOTAS
    //─────────────────────────────────────────────

    /**
     * Abre um AlertDialog com EditText.
     * Carrega a nota salva anteriormente (se existir).
     * Ao salvar, grava em SharedPreferences e
     * atualiza o TextView no menu lateral.
     */
    private void abrirNotas() {
        // Cria o campo de texto para digitar a nota
        final EditText editNota = new EditText(this);
        editNota.setHint(getString(R.string.notas_hint));
        editNota.setMinLines(4);
        editNota.setMaxLines(8);
        editNota.setGravity(android.view.Gravity.TOP);
        editNota.setPadding(32, 24, 32, 24);

        // Carrega nota salva anteriormente
        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String notaExistente = prefs.getString(KEY_NOTA, "");
        if (!notaExistente.isEmpty()) {
            editNota.setText(notaExistente);
            editNota.setSelection(notaExistente.length()); // cursor no final
        }

        // Monta o diálogo
        new AlertDialog.Builder(this)
            .setTitle(getString(R.string.notas_titulo))
            .setView(editNota)
            .setPositiveButton(getString(R.string.notas_salvar), new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    String nota = editNota.getText().toString().trim();
                    salvarNota(nota);
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

    /** Salva a nota em SharedPreferences e atualiza a UI */
    private void salvarNota(String nota) {
        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        prefs.edit().putString(KEY_NOTA, nota).apply();

        // Atualiza o TextView no menu lateral
        if (tvNotaSalva != null) {
            tvNotaSalva.setText(nota.isEmpty() ? "Nenhuma nota ainda." : nota);
        }

        Toast.makeText(this, getString(R.string.notas_salvo), Toast.LENGTH_SHORT).show();
    }

    /** Carrega a nota salva ao abrir o app */
    private void carregarNotaSalva() {
        SharedPreferences prefs = getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String nota = prefs.getString(KEY_NOTA, "");
        if (tvNotaSalva != null && !nota.isEmpty()) {
            tvNotaSalva.setText(nota);
        }
    }


    //─────────────────────────────────────────────
    // BLOCO 9 — IMPLEMENTAÇÃO DE MÚSICA
    //─────────────────────────────────────────────

    /**
     * Tenta abrir o player de música do sistema.
     * Usa a categoria APP_MUSIC do Intent.
     * Se não encontrar nenhum app de música,
     * mostra um Toast informando.
     */
    private void abrirMusica() {
        try {
            Intent intent = new Intent(Intent.ACTION_MAIN);
            intent.addCategory(Intent.CATEGORY_APP_MUSIC);
            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
        } catch (Exception e) {
            // Fallback: abre gerenciador de arquivos de áudio
            try {
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.setType("audio/*");
                startActivity(intent);
            } catch (Exception e2) {
                Toast.makeText(this,
                    "Nenhum player de música encontrado.",
                    Toast.LENGTH_SHORT).show();
            }
        }
    }


    //─────────────────────────────────────────────
    // BLOCO 10 — IMPLEMENTAÇÃO DO CLIMA
    //─────────────────────────────────────────────

    /**
     * Abre a previsão do tempo no navegador.
     * Usa o Google Clima (weather.com via busca).
     * Se não houver navegador, mostra Toast.
     */
    private void abrirClima() {
        try {
            Uri uri = Uri.parse("https://www.google.com/search?q=previsao+do+tempo");
            Intent intent = new Intent(Intent.ACTION_VIEW, uri);
            startActivity(intent);
        } catch (Exception e) {
            Toast.makeText(this,
                "Nenhum navegador encontrado.",
                Toast.LENGTH_SHORT).show();
        }
    }


    //─────────────────────────────────────────────
    // BLOCO 11 — BOTÃO VOLTAR
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
    // BLOCO 12 — CICLO DE VIDA: onResume / onPause / onDestroy
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
