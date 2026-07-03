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
