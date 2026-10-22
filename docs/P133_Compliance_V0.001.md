# P133 V0.002 交付前合規檢查

執行日期：2026-10-22  
基準：SBI-P-SDS v3.4

| 編號 | 結果 | 說明 |
|---|---|---|
| QA-01 | PASS（設計） | `TblP133...` 均在 migration 中啟用 RLS。部署後需執行 Health Check 再確認。 |
| QA-02 | PASS | 前端未使用 Supabase `.from()`、REST 或 GraphQL table/view 呼叫。 |
| QA-03 | PASS | V0.001 為純靜態示範；下一階段資料交換已限定為 `p133_api` RPC。 |
| QA-04 | REVIEW | 需由專案管理者在 Supabase Dashboard 確認只暴露 `p133_api`，不暴露 `p133_data`。 |
| QA-05 | PASS（設計） | migration 逐表設定 grants；未使用跨 schema 的全域 grants 或 default privileges。 |
| QA-06 | PASS（設計） | 公開唯讀 policy 僅限 `Status='active'`；寫入未授權。 |
| QA-07 | PASS | RPC 明列必要回傳欄位，未使用 `SELECT *`。 |
| QA-08 | PASS（設計） | RPC 均先撤除 `PUBLIC EXECUTE`，再精確授權 anon/authenticated 的唯讀函式。 |
| QA-09 | PASS | RPC 使用 `SECURITY INVOKER`，並指定 `search_path`。 |
| QA-10 | PASS | 此公開唯讀階段不授予 sequence 權限，也未含任何 secret。 |
| QA-11 | N/A | V0.001 不含帳號與密碼欄位。 |

## 交付結論

**PASS，附帶 QA-04 的部署前人工確認。** 此 ZIP 未含 `config.js`、service role 或任何可用秘密。正式接入 Supabase 前，應執行 `database/99_P133_HealthCheck.sql` 並完成其註記的 Data API 實測。
