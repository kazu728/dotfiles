{ config, lib, pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_rpi4;
    kernelParams = [
      "cgroup_enable=cpuset"
      "cgroup_enable=memory"
      "cgroup_memory=1"
      "systemd.unified_cgroup_hierarchy=1"
      
      "gpu_mem=256"
      "arm_boost=1"
      "arm_freq=1800"
      "over_voltage=6"
    ];
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "usbhid"
        "usb_storage"
        "vc4"
        "bcm2835_dma"
        "i2c_bcm2835"
      ];
      kernelModules = [ "vc4" "bcm2835_dma" ];
    };
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [
        "noatime"
        "nodiratime"
        "commit=60"
        "barrier=0"
        "data=writeback"
      ];
    };
  };
  
  swapDevices = [];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  hardware = {
    enableRedistributableFirmware = true;
    deviceTree = {
      enable = true;
      filter = "bcm2711-rpi-4-*.dtb";
    };
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.vfs_cache_pressure" = 500;
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
    "vm.dirty_expire_centisecs" = 6000;
  };
}