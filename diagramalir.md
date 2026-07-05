# Diagram Alir — Smart Contract `InsurancePolicy`

---

## 1. Deployment Kontrak

```mermaid
flowchart TD
    A([🟢 MULAI]) --> B[/Deploy kontrak oleh msg.sender/]
    B --> C[owner = msg.sender]
    C --> D[(Simpan owner di Blockchain)]
    D --> E([🔴 SELESAI])
```

---

## 2. `createPolicy` — Membuat Polis Baru

```mermaid
flowchart TD
    A([🟢 MULAI]) --> B[/INPUT: policyId, customerName, customerAddress, premium/]
    B --> C{msg.sender == owner?}
    C -- TIDAK --> D[/Revert: 'Hanya perusahaan'/]
    D --> E([🔴 STOP])
    C -- YA --> F{policies policyId sudah ada?}
    F -- YA --> G[/Revert: 'Policy sudah ada'/]
    G --> H([🔴 STOP])
    F -- TIDAK --> I[Buat struct Policy\nstatus = Aktif, exists = true]
    I --> J[(Simpan policies ke Blockchain)]
    J --> K[[Emit event PolicyCreated]]
    K --> L[/OUTPUT: Event Log policyId, customerName, customerAddress/]
    L --> M([🔴 SELESAI])
```

---

## 3. `setPolicyActive` — Ubah Status Menjadi Aktif

```mermaid
flowchart TD
    A([🟢 MULAI]) --> B[/INPUT: policyId/]
    B --> C{msg.sender == owner?}
    C -- TIDAK --> D[/Revert: 'Hanya perusahaan'/]
    D --> E([🔴 STOP])
    C -- YA --> F{policies policyId exists?}
    F -- TIDAK --> G[/Revert: 'Policy tidak ditemukan'/]
    G --> H([🔴 STOP])
    F -- YA --> I[status = PolicyStatus.Aktif]
    I --> J[(Update policies di Blockchain)]
    J --> K[[Emit event StatusUpdated]]
    K --> L[/OUTPUT: Event Log policyId, status = Aktif/]
    L --> M([🔴 SELESAI])
```

---

## 4. `setPolicyClaimed` — Ubah Status Menjadi Cair

```mermaid
flowchart TD
    A([🟢 MULAI]) --> B[/INPUT: policyId/]
    B --> C{msg.sender == owner?}
    C -- TIDAK --> D[/Revert: 'Hanya perusahaan'/]
    D --> E([🔴 STOP])
    C -- YA --> F{policies policyId exists?}
    F -- TIDAK --> G[/Revert: 'Policy tidak ditemukan'/]
    G --> H([🔴 STOP])
    F -- YA --> I[status = PolicyStatus.Cair]
    I --> J[(Update policies di Blockchain)]
    J --> K[[Emit event StatusUpdated]]
    K --> L[/OUTPUT: Event Log policyId, status = Cair/]
    L --> M([🔴 SELESAI])
```

---

## 5. `checkPolicyStatus` — Cek Status Polis

```mermaid
flowchart TD
    A([🟢 MULAI]) --> B[/INPUT: policyId/]
    B --> C{policies policyId exists?}
    C -- TIDAK --> D[/Revert: 'Policy tidak ditemukan'/]
    D --> E([🔴 STOP])
    C -- YA --> F{status == Aktif?}
    F -- YA --> G[/OUTPUT: return 'Aktif'/]
    F -- TIDAK --> H[/OUTPUT: return 'Cair'/]
    G --> I([🔴 SELESAI])
    H --> I
```

---

## 6. `getPolicy` — Ambil Detail Polis

```mermaid
flowchart TD
    A([🟢 MULAI]) --> B[/INPUT: policyId/]
    B --> C{policies policyId exists?}
    C -- TIDAK --> D[/Revert: 'Policy tidak ditemukan'/]
    D --> E([🔴 STOP])
    C -- YA --> F[(Baca struct Policy dari Blockchain)]
    F --> G{status == Aktif?}
    G -- YA --> H[statusText = 'Aktif']
    G -- TIDAK --> I[statusText = 'Cair']
    H --> J[/OUTPUT: policyId, customerName, customerAddress, premium, statusText/]
    I --> J
    J --> K([🔴 SELESAI])
```

---

## 7. Sistem Keseluruhan

```mermaid
flowchart TD
    A([🟢 MULAI]) --> B[/INPUT: Transaksi dari User/]
    B --> C{Fungsi yang Dipanggil?}

    C -- createPolicy --> D[[Validasi owner + cek duplikat]]
    D --> E[(Simpan polis baru)]
    E --> F[[Emit PolicyCreated]]

    C -- setPolicyActive --> G[[Validasi owner + cek exists]]
    G --> H[(Update status = Aktif)]
    H --> I[[Emit StatusUpdated]]

    C -- setPolicyClaimed --> J[[Validasi owner + cek exists]]
    J --> K[(Update status = Cair)]
    K --> L[[Emit StatusUpdated]]

    C -- checkPolicyStatus --> M[[Cek exists]]
    M --> N[/OUTPUT: 'Aktif' atau 'Cair'/]

    C -- getPolicy --> O[[Cek exists]]
    O --> P[(Baca data polis)]
    P --> Q[/OUTPUT: Detail lengkap polis/]

    F --> Z([🔴 SELESAI])
    I --> Z
    L --> Z
    N --> Z
    Q --> Z
```

---

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
