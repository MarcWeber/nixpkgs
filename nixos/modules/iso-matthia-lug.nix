{ config, pkgs, ... }:

let

  mesa_treiber = "ati_unfree";
  sonstigesHilfe = pkgs.writeScriptBin "hilfe-sonstiges" ''
  #!/bin/sh
  cat << EOF
  Backup ganze Festplatte:

        dd if=/dev/sda of=/backup-platz bs=16M

      oder mit Fortschrittsanzeige:
        pv /dev/sda > backup-platz
        pv backup-platz > /dev/sda

  '';

  backupHilfe = pkgs.writeScriptBin "hilfe-backup-storebackup" ''
  #!/bin/sh
  cat << EOF
  Steps Backup machen:
  ===================
  1) Sicherstellen, dass auf Festplatte nicht mehr geschrieben wird.
    Lösung 1) Live-CD
    Lösung 2)
      mount -oro,remount /
      mount -oro,remount /anderes-gemountetes-verzeichnis
  2) Backup Festplatte mounten: mount /dev/sdXN /mnt

  3)
    Folge backup-machen unten.

  Steps Backup zurückspielen:
  ===========================
  1) Partition löschen (rm -fr)
  2) backup-zurueckkopieren (folgen)
  3) Boot-Loader (nur bei neuer Festplatte) einrichten:
       grub-install /dev/sda (oder so ähnlich)


  backup-machen:
    storeBackup.pl --sourceDir "ZU_SICHERN" --backupDir "NACH"

  backup-zurueckkopieren:
    storeBackupRecover.pl -b "BACKUP_VERZ_MIT_DATUM" -t "ZIEL_VERZ -r "/"

    "/" bedeutet alles. Alternative "/home/du/oder/sowas"

  Backup vergleichen:
    storeBackupCheckSource.pl -s "GESICHERT" -b "BACKUP_VERZ_MIT_DATUM"

  Backup Integrität
    neu mounten, oder "echo 3 > /proc/sys/vm/drop_caches"
    um sicherzustellen, dass Daten von Festplatte geladen werden und nicht vom
    Cache stammen

    storeBackupCheckBackup.pl -c "BACKUP_VERZ_MIT_DATUM"

  EOF
  '';


  # backupBupHilfe = pkgs.writeScriptBin "backup-bup-hilfe" ''
  # #!/bin/sh
  # cat << EOF
  # bup: schneller, experimentell (?), keine Möglichkeit alte Backups zu löschen

  # Steps Backup machen:
  # ===================
  # 1) Sicherstellen, dass auf Festplatte nicht mehr geschrieben wird.
  #   Lösung 1) Live-CD
  #   Lösung 2)
  #     mount -oro,remount /
  #     mount -oro,remount /anderes-gemountetes-verzeichnis
  # 2) Backup Festplatte mounten: mount /dev/sdXN /mnt

  # 3)
  #   Folge backup-machen unten.

  # Steps Backup zurückspielen:
  # ===========================
  # 1) Partition löschen (rm -fr)
  # 2) backup-zurueckkopieren (folgen)
  # 3) Boot-Loader (nur bei neuer Festplatte) einrichten:
  #      grub-install /dev/sda (oder so ähnlich)

  # backup-machen:
  #   export BUP_DIR=BACKUP_VERZ

  #   Beim ersten Mal: bup init

  #   cd verz-von-dem-backup-gemacht-werden-soll;
  #   tar -cvf - . | bup split -n backup-name
  #   bup fsck

  # backup-zurueckkopieren:
  #   export BUP_DIR=BACKUP_VERZ
  #   cd ziel-verzeichnis; bup join backup | tar vxf -

  #   Vorletztes Backup mit backup^ oder backup^^ etc..

  # Backup Integrität
  #   bup fsck

  # EOF
  # '';

  sshForward = pkgs.writeScriptBin "ssh-forward-at-mawercer" ''
  #!/bin/sh
  systemctl start sshd
  exec ssh -NR\*:8012:localhost:22 matthias_mundelfingen@mawercer.de
  '';

  sshMawercer = pkgs.writeScriptBin "hilfe-zugriff-fuer-marc" ''
  #!/bin/sh
  cat << EOF
  1) Passwort für root (live-cd) vergeben mit "passwd"


  2) Ausführen, Passwort was du von Marc bekommst eingeben. Dies veröffentlicht
     deinen Port 22 as Port 8012 auf mawercer.de:

    ssh-forward-at-mawercer

    Dann mit ctrl-z und dem Befehl "bg" in den Hintergrund bringen

  3) "screen" starten
  EOF
  '';
in

{
  require =
    [ ./installer/cd-dvd/installation-cd-base.nix
      ./profiles/minimal.nix
    ];

  # services.mesa.videoDrivers = [mesa_treiber];
  services.xserver = {
    enable = true;
    displayManager.kdm.enable = true;
    desktopManager.kde4.enable = true;
    desktopManager.xfce.enable = true;
  };

  fonts = {
    enableFontConfig = true;
    enableFontDir = true;
    extraFonts = [
      # pkgs.fonts.droidSerif
      # pkgs.dejavu_fonts
      # pkgs.vistafonts
      # pkgs.andagii
      # pkgs.anonymousPro
      # pkgs.arkpandora_ttf
      # pkgs.bakoma_ttf
      # pkgs.corefonts
      # pkgs.clearlyU
      # pkgs.cm_unicode
      # pkgs.dejavu_fonts
      # pkgs.freefont_ttf
      # pkgs.gentium
      # pkgs.inconsolata
      # pkgs.junicode
      # pkgs.liberation_ttf
      # pkgs.libertine
      # pkgs.lmodern
      # pkgs.mph_2b_damase
      # pkgs.oldstandard
      # pkgs.theano
      # pkgs.tempora_lgc
      # pkgs.terminus_font
      # pkgs.ttf_bitstream_vera
      # pkgs.ucsFonts
      # pkgs.unifont
      # pkgs.vistafonts
      # pkgs.wqy_zenhei
      # pkgs.xfontsel
      # pkgs.xlsfonts
      # pkgs.base14Fonts
      ];
    enableGnostscriptFonts = true;
  };

  users.defaultUserShell = "/run/current-system/sw/bin/bash";
  services.xserver.autorun = pkgs.lib.mkForce false;

  nixpkgs.config = {
    bup.par2Support = true;
  };

  environment.systemPackages = [
    # graphical:
    pkgs.glxinfo

    pkgs.file
    backupHilfe
    # backupBupHilfe
    sshMawercer
    pkgs.screen
    pkgs.storeBackup
    # pkgs.bup
    sshForward
    sonstigesHilfe

    pkgs.thunderbird
    pkgs.firefoxWrapper
    pkgs.gimp
    pkgs.pv
  ];

  services.openssh = {
    enable = true;
    allowSFTP = true;
    #startOn = mkDefaultValue "never";
    passwordAuthentication = false;
    challengeResponseAuthentication = true;
    permitRootLogin = "yes";
  };

  services.mingetty.helpLine = pkgs.lib.mkOverride 50
    ''
      Hi Matthias, log dich ein als "root" mit leerem Passwort.

      ==> hilfe-sonstiges (backup ganze Festplatte)
      ==> hilfe-backup-storebackup (info wie storebackup verwenden)
      ==> hilfe-zugriff-fuer-marc (oder jemand anderes per SSH)
      ==> loadkeys de (Deutsches Tastaturlayout)

      ==> systemctl start display-manager (X-Server xfce starten, treiber ${mesa_treiber}): 
      Firefox, Gimp, Thunderbird sind verfügbar

      Erinnerung <tab> Taste ergänzt Befehle
   '';
}
