#!/bin/bash

VM_NAME="MyUbuntuVM24D"
ISO_PATH="/home/rut/Загрузки/ubuntu-24.04.3-desktop-amd64.iso"
DISK_SIZE=20480  # в MB
MEMORY=2048      # в MB
CPUS=2

echo "Создание виртуальной машины: $VM_NAME"

# Создать VM
VBoxManage createvm --name "$VM_NAME" --ostype "Ubuntu_64" --register

# Настроить базовые параметры
VBoxManage modifyvm "$VM_NAME" \
    --memory $MEMORY \
    --cpus $CPUS \
    --acpi on \
    --boot1 dvd \
    --boot2 disk \
    --boot3 none \
    --boot4 none

# Добавить контроллер SATA для основного диска
VBoxManage storagectl "$VM_NAME" \
    --name "SATA Controller" \
    --add sata \
    --controller IntelAhci

# Создать виртуальный диск
VBoxManage createhd \
    --filename "${VM_NAME}.vdi" \
    --size $DISK_SIZE \
    --variant Standard

# Присоединить диск к VM
VBoxManage storageattach "$VM_NAME" \
    --storagectl "SATA Controller" \
    --port 0 \
    --device 0 \
    --type hdd \
    --medium "${VM_NAME}.vdi"

# Добавить контроллер IDE для DVD
VBoxManage storagectl "$VM_NAME" \
    --name "IDE Controller" \
    --add ide

# Присоединить ISO образ
VBoxManage storageattach "$VM_NAME" \
    --storagectl "IDE Controller" \
    --port 0 \
    --device 0 \
    --type dvddrive \
    --medium "$ISO_PATH"

# Настроить сеть (NAT)
VBoxManage modifyvm "$VM_NAME" --nic1 nat

echo "Виртуальная машина '$VM_NAME' успешно создана!"