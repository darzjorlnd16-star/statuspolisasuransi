# Diagram Use Case — Smart Contract `InsurancePolicy`

```mermaid
graph LR
    %% Aktor
    OW(["👤 Perusahaan Asuransi\n(Owner)"])
    NS(["👤 Nasabah\n(Customer)"])
    BC(["⛓️ Blockchain\n(Smart Contract)"])

    %% Batas Sistem
    subgraph SISTEM ["🔲 Sistem InsurancePolicy"]
        UC1(["📋 Membuat Polis Baru\n(createPolicy)"])
        UC2(["✅ Mengubah Status Aktif\n(setPolicyActive)"])
        UC3(["💰 Mengubah Status Cair\n(setPolicyClaimed)"])
        UC4(["🔍 Cek Status Polis\n(checkPolicyStatus)"])
        UC5(["📄 Lihat Detail Polis\n(getPolicy)"])
        UC6(["🚀 Deploy Kontrak"])
    end

    %% Relasi Owner
    OW --> UC6
    OW --> UC1
    OW --> UC2
    OW --> UC3
    OW --> UC4
    OW --> UC5

    %% Relasi Nasabah
    NS --> UC4
    NS --> UC5

    %% Relasi Blockchain
    UC6 --> BC
    UC1 --> BC
    UC2 --> BC
    UC3 --> BC
    UC4 --> BC
    UC5 --> BC
```

---

## Tabel Relasi Use Case

| Use Case | Aktor | Akses | Keterangan |
|---|---|---|---|
| Deploy Kontrak | Perusahaan Asuransi | `onlyOwner` | Inisialisasi kontrak, set owner |
| `createPolicy` | Perusahaan Asuransi | `onlyOwner` | Membuat polis baru untuk nasabah |
| `setPolicyActive` | Perusahaan Asuransi | `onlyOwner` | Mengubah status polis menjadi Aktif |
| `setPolicyClaimed` | Perusahaan Asuransi | `onlyOwner` | Mengubah status polis menjadi Cair |
| `checkPolicyStatus` | Perusahaan & Nasabah | `public view` | Melihat status polis (Aktif/Cair) |
| `getPolicy` | Perusahaan & Nasabah | `public view` | Melihat detail lengkap polis |
