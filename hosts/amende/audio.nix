{
  services.pipewire.wireplumber.extraConfig = {
    "10-volume"."wireplumber.settings" = {
      "device.routes.default-sink-volume" = 1.0;
      "device.routes.default-source-volume" = 0.4 * 0.4 * 0.4;
    };

    "20-disable-elgato-wave-3-sink"."monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" = "alsa_output.usb-Elgato_Systems_Elgato_Wave_3_BS41K1A03938-00.analog-stereo";
          }
        ];
        actions.update-props = {
          "node.disabled" = true;
        };
      }
    ];

    "21-disable-built-in-audio-device"."monitor.alsa.rules" = [
      {
        matches = [
          {
            "device.name" = "alsa_card.pci-0000_00_1f.3";
          }
        ];
        actions.update-props = {
          "device.disabled" = true;
        };
      }
    ];
  };
}
