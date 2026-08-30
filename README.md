# kn_policearmor

[![Version](https://img.shields.io/badge/version-1.1.0-blue.svg)](CHANGELOG.md)
[![Framework](https://img.shields.io/badge/framework-QBCore%20%7C%20QBox%20%7C%20ESX-green.svg)](#requirements)
[![License](https://img.shields.io/badge/license-MIT-lightgrey.svg)](LICENSE)

Grants armor automatically when an on-duty officer enters a designated police
vehicle. Job and vehicle are both validated **server-side**, so the armor cannot
be obtained by firing the event manually.

指定した警察車両に乗り込んだときにアーマーを自動付与します。ジョブと車両は
**サーバー側で検証**するため、イベントを直接叩いてアーマーを得ることはできません。

---

## Requirements / 必要環境

| | |
|---|---|
| Dependency | `ox_lib` (required) |
| Framework | QBCore (`qb-core`) / QBox (`qbx_core`) / ESX (`es_extended`) |
| Standalone | **Not supported** — a framework is required to resolve the player's job |

> **Standalone では動作しません。** ジョブを解決できないと必ず付与を拒否します。

## Installation / 導入

1. Place `kn_policearmor` in your `resources` folder.
2. Add `ensure kn_policearmor` to `server.cfg`, **after** `ox_lib` and your framework.
3. Edit `Config.Jobs` and `Config.Vehicles` to match your server.

```cfg
ensure ox_lib
ensure kn_policearmor
```

## Configuration / 設定

| Key | Default | Description |
|---|---|---|
| `Config.ArmorAmount` | `100` | Armor value applied (clamped to 0–200) |
| `Config.Jobs` | `police`, `leo` | Jobs allowed to receive armor |
| `Config.Vehicles` | vanilla police vehicles | Spawn names that trigger the effect |
| `Config.Sound` | `Pick_Up_Armor` | Sound played on the client when armor is applied |
| `Config.Debug` | `false` | Debug output |

> `Config.Jobs` の既定値は `police` / `leo` です。**QBCore / QBox / ESX はいずれも
> `admin` ジョブを既定で持たない**ため、実在するジョブ名に合わせてください。

## Command / コマンド

### `/knarmor <0-200>`

Changes `Config.ArmorAmount` at runtime.

- Requires the ACE permission `command.knarmor` (or console).
- **The change is not persisted** — it resets to the `config.lua` value on restart.
- 値はサーバー再起動で `config.lua` の値に戻ります。恒久的に変えるなら
  `config.lua` を編集してください。

```cfg
add_ace group.admin command.knarmor allow
```

## Behavior notes / 挙動について

- Detection uses `lib.onCache('vehicle')`, so it fires on **entering** a vehicle
  (including a seat change into a configured vehicle), not continuously.
- Armor is reset to `0` and re-applied after a 100 ms wait. This is intentional:
  setting the same value twice does not resynchronize reliably.
- A **5-second server-side cooldown** per player prevents event spam.
- 車両モデルの照合は `GetHashKey` による完全一致です。**車種の派生（`police4` など）は
  自動では含まれません。**使う車両はすべて `Config.Vehicles` に列挙してください。

## Performance

| State | resmon |
|---|---|
| Idle | 0.00 ms |
| Active | 0.00 ms |

There is no per-frame loop; the client only reacts to the `ox_lib` vehicle cache
event. 毎フレームのループは存在しません。

## License

MIT — see [LICENSE](LICENSE).
