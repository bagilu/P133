# P133 國土比一比 / GeoShift — V0.004

以拖曳與對照地理實體，理解真實面積、尺度、形狀與地圖投影的差異。

## 本版可用功能

- 世界行政區域底圖，內含國界、州／省級行政界與 1,010 個重要城市點位。
- 臺灣改用 Natural Earth 1:10m 的精細輪廓（406 點）作為原位置及半透明比較者。
- 世界原位置的臺灣（或其他比較者）仍保留；另有可拖曳的半透明比較者。
- 拖曳比較者移動；拖曳空白地圖平移；滾輪／觸控板縮放；Shift + 拖曳比較者旋轉。
- 以地表公尺尺度置入比較者，顯示城市距離、比例尺與實體南北長度。

V0.001 的輪廓為教學互動原型，並非可用於行政、法律或精密測量的邊界資料。詳見 `docs/DATA_STATUS.md`。

## 直接使用

本版不需要 Node、npm 或 Supabase。將整個資料夾上傳到 GitHub repository 根目錄，啟用 GitHub Pages 即可。

`config-sample.js` 是未來串接 Supabase 的設定範例；不得將實際 `config.js` 或任何 secret 提交至 GitHub。

## v3.4 資料庫準備

`database/` 提供下一階段接入權威資料的 migration 範本。其設計為：

1. `p133_data`：不暴露於 Data API 的資料 schema；
2. `p133_api`：唯一預定暴露的 RPC schema；
3. 全表啟用 RLS，前端將來僅能經 P133 RPC 讀取必要欄位；
4. Function 使用 `SECURITY INVOKER`，並撤除 `PUBLIC EXECUTE`。

部署前，請先在 Supabase 的 Data API **Exposed Schemas** 中加入 `p133_api`，且不要加入 `p133_data`。執行 SQL 後，再依 `99_P133_HealthCheck.sql` 核對。

## 版本規則

目前可見版本：**P133 Web Version V0.004**。今後每次會改變使用者可見或可操作行為的 HTML/CSS/JS 更新，版本號及各靜態檔 query string 均須同步遞增。

## 後續工作

- 導入具授權與版本資訊的正式 GeoJSON 邊界資料。
- 以 P133 RPC 取代本機 `data/entities.js`。
- 對「同一名稱、不同統計口徑」建立 comparison variant。
- 增加地圖重疊、題組與教學紀錄功能。
