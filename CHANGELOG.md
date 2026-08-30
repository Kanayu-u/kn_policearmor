# Changelog

## [1.1.0] - 2026-08-28

GitHub 公開に向けた整備。

### Changed
- **`Config.Vehicles` の既定値を addon の `nboxville` からバニラの警察車両
  （`police` / `police2` / `police3` / `sheriff` / `sheriff2`）へ変更。**
  addon 前提の既定値のままでは、そのまま導入しても何も起きなかった。
- `Config.Jobs` の既定から `admin` を削除。QBCore / QBox / ESX はいずれも
  `admin` ジョブを既定で持たないため、一致しない値が既定に入っていた。
- README を全面的に書き直し（依存・Standalone 非対応・`/knarmor` が
  再起動で戻ること・車両モデルは完全一致であることを明記）。

### Removed
- `escrow_ignore` を削除（有償販売ではなく MIT での公開に切り替えたため）。

### Added
- `LICENSE`（MIT）。

## [1.0.1] - 2026-07-14
### Security
- `kn_policearmor:attemptArmor` にサーバー側検証を追加：対象車両（`Config.Vehicles`）に実際に搭乗しているかを確認し、イベント直接発火による不正なアーマー取得を防止。
- 同イベントに 5 秒のクールダウンを追加（スパム防止）。
- `/knarmor` コマンドの値を 0〜200 にクランプ（異常値の注入防止）。

### Changed
- `author` 表記を 'Kanayu_u' に統一。
- `escrow_ignore`（config.lua / README.md）を追加し、購入者が設定を編集可能に。

## [1.0.0]
### Added
- 初回リリース（指定車両乗車時に職業チェックの上アーマーを付与、QBX/QBCore/ESX 対応）。
