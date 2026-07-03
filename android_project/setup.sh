#!/bin/bash
#=================================================
# SETUP.SH — Gerador automático do projeto Android
# Execute no Termux: bash setup.sh
# Cria toda a estrutura de pastas e arquivos.
# Versão com widgets de prática no menu lateral.
#=================================================

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
<FrameLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent">

    <LinearLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:orientation="vertical">

        <FrameLayout
            android:id="@+id/section_top"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="1"
            android:background="@color/section_top">

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

        <FrameLayout
            android:id="@+id/section_bottom"
            android:layout_width="match_parent"
            android:layout_height="0dp"
            android:layout_weight="1"
            android:background="@color/section_bottom">

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

    <FrameLayout
        android:id="@+id/nav_drawer"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:background="@color/drawer_bg"
        android:visibility="gone">

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

        <ScrollView
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            android:layout_marginTop="70dp"
            android:layout_marginBottom="16dp"
            android:layout_marginHorizontal="24dp">

            <LinearLayout
                android:layout_width="match_parent"
                android:layout_height="wrap_content"
                android:orientation="vertical"
                android:gravity="center_horizontal">

                <TextView
                    android:layout_width="wrap_content"
                    android:layout_height="wrap_content"
                    android:text="@string/drawer_title"
                    android:textSize="32sp"
                    android:textColor="@color/text_light"
                    android:textStyle="bold"
                    android:layout_marginBottom="24dp" />

                <TextView
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:text="Seu nome:"
                    android:textColor="@color/text_light_dim"
                    android:textSize="14sp"
                    android:layout_marginBottom="4dp" />

                <EditText
                    android:id="@+id/et_name"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:hint="Digite aqui"
                    android:textColor="@color/text_light"
                    android:textColorHint="@color/text_light_dim"
                    android:background="@android:drawable/edit_text"
                    android:padding="12dp" />

                <Button
                    android:id="@+id/btn_update"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="16dp"
                    android:text="Atualizar"
                    android:textColor="@color/text_light"
                    android:background="@color/section_bottom" />

                <Switch
                    android:id="@+id/switch_option"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="24dp"
                    android:text="Modo noturno"
                    android:textColor="@color/text_light"
                    android:textSize="16sp" />

                <CheckBox
                    android:id="@+id/cb_option"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="16dp"
                    android:text="Lembrar preferências"
                    android:textColor="@color/text_light"
                    android:textSize="16sp" />

                <TextView
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="24dp"
                    android:text="Tamanho do texto:"
                    android:textColor="@color/text_light_dim"
                    android:textSize="14sp" />

                <SeekBar
                    android:id="@+id/seek_size"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="8dp"
                    android:max="50"
                    android:progress="22" />

                <TextView
                    android:id="@+id/tv_result"
                    android:layout_width="match_parent"
                    android:layout_height="wrap_content"
                    android:layout_marginTop="32dp"
                    android:background="@color/section_top"
                    android:padding="16dp"
                    android:text="Resultado aparece aqui"
                    android:textColor="@color/text_light"
                    android:textSize="16sp" />

            </LinearLayout>

        </ScrollView>

    </FrameLayout>

</FrameLayout>
ENDOFFILE

echo "      OK"

#─────────────────────────────────────────────
# BLOCO 4 — MainActivity.java
#─────────────────────────────────────────────
echo "[4/8] Criando src/com/meuapp/MainActivity.java..."

cat > "$PROJECT/src/com/meuapp/MainActivity.java" << 'ENDOFFILE'
package com.meuapp;

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

public class MainActivity extends Activity {

    private TextView    tvClock;
    private FrameLayout navDrawer;
    private Button      btnMenu;
    private Button      btnCloseDrawer;

    private EditText   etName;
    private Button     btnUpdate;
    private Switch     switchOption;
    private CheckBox   cbOption;
    private SeekBar    seekSize;
    private TextView   tvResult;

    private Handler  clockHandler;
    private Runnable clockRunnable;

    private static final SimpleDateFormat TIME_FORMAT =
            new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
    private static final long CLOCK_INTERVAL_MS = 1000L;
    private static final long ANIM_FADE_IN_MS  = 250L;
    private static final long ANIM_FADE_OUT_MS = 180L;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        initViews();
        initClock();
        initDrawer();
        initPracticeWidgets();
    }

    private void initViews() {
        tvClock        = findViewById(R.id.tv_clock);
        navDrawer      = findViewById(R.id.nav_drawer);
        btnMenu        = findViewById(R.id.btn_menu);
        btnCloseDrawer = findViewById(R.id.btn_close_drawer);
    }

    private void initClock() {
        clockHandler = new Handler(Looper.getMainLooper());
        clockRunnable = new Runnable() {
            @Override
            public void run() {
                tvClock.setText(TIME_FORMAT.format(new Date()));
                clockHandler.postDelayed(this, CLOCK_INTERVAL_MS);
            }
        };
    }

    private void initDrawer() {
        btnMenu.setOnClickListener(v -> openDrawer());
        btnCloseDrawer.setOnClickListener(v -> closeDrawer());
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

    private void initPracticeWidgets() {
        etName       = findViewById(R.id.et_name);
        btnUpdate    = findViewById(R.id.btn_update);
        switchOption = findViewById(R.id.switch_option);
        cbOption     = findViewById(R.id.cb_option);
        seekSize     = findViewById(R.id.seek_size);
        tvResult     = findViewById(R.id.tv_result);

        btnUpdate.setOnClickListener(v -> updateResult());

        switchOption.setOnCheckedChangeListener((buttonView, isChecked) -> updateResult());
        cbOption.setOnCheckedChangeListener((buttonView, isChecked) -> updateResult());

        seekSize.setOnSeekBarChangeListener(new SeekBar.OnSeekBarChangeListener() {
            @Override
            public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
                tvResult.setTextSize(12 + progress);
                updateResult();
            }
            @Override public void onStartTrackingTouch(SeekBar seekBar) { }
            @Override public void onStopTrackingTouch(SeekBar seekBar) { }
        });

        updateResult();
    }

    private void updateResult() {
        String nome = etName.getText().toString().trim();
        if (nome.isEmpty()) nome = "Visitante";

        boolean noturno = switchOption.isChecked();
        boolean lembrar = cbOption.isChecked();
        int tamanho     = seekSize.getProgress() + 12;

        tvResult.setText(
            "Olá, " + nome + "!\n" +
            "Modo noturno: " + (noturno ? "ligado" : "desligado") + "\n" +
            "Lembrar: " + (lembrar ? "sim" : "não") + "\n" +
            "Texto: " + tamanho + "sp"
        );
    }

    @Override
    public void onBackPressed() {
        if (navDrawer.getVisibility() == View.VISIBLE) {
            closeDrawer();
        } else {
            super.onBackPressed();
        }
    }

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
# BLOCO 5 — colors.xml
#─────────────────────────────────────────────
echo "[5/8] Criando res/values/colors.xml..."

cat > "$PROJECT/res/values/colors.xml" << 'ENDOFFILE'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="section_top">#1A237E</color>
    <color name="section_bottom">#283593</color>
    <color name="drawer_bg">#0D1B6B</color>
    <color name="text_light">#FFFFFF</color>
    <color name="text_light_dim">#90CAF9</color>
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
<resources>
    <string name="app_name">MeuApp</string>
    <string name="status_msg">&#10004; Funcionando</string>
    <string name="menu_desc">Abrir menu lateral</string>
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
<resources>
    <style name="AppTheme" parent="android:Theme.Material.NoActionBar">
        <item name="android:statusBarColor">#1A237E</item>
        <item name="android:navigationBarColor">#1A237E</item>
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
echo "  Próximo passo:"
echo "  cd $PROJECT && ./build.sh"
echo "========================================"
echo ""
