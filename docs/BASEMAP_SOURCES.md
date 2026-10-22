# V0.003 公開行政界底圖

本 ZIP 內的下列資料來自 Natural Earth 1:110m Cultural Vectors：

- `ne_110m_admin_0_countries.geojson`：國家／地區行政界，版本 5.1.1。
- `ne_110m_admin_1_states_provinces.geojson`：州／省級行政界，版本 5.1.1。
- `ne_110m_populated_places.geojson`：城市點位，版本 5.1.2。

V0.004 另加入：

- `taiwan_detailed.geojson`：Natural Earth 1:10m Admin 0 Countries v5.1.1 中的臺灣輪廓，406 個原始座標點。
- `cities_important.geojson`：由 Natural Earth 1:10m Populated Places v5.1.2 篩選人口 50 萬以上城市，並保留鄭州、洛陽、開封、新鄉、許昌等教學情境城市；共 1,010 點。

V0.005 另加入：

- `shikoku_detailed.geojson`：Natural Earth `ne_10m_admin_0_countries` 1:10m 日本 MultiPolygon 中的四國島主要島嶼海岸線，473 個原始座標點。範圍為四國本島海岸線，不以四縣行政邊界替代；關聯小離島不納入這個比較輪廓。

Natural Earth 為 public domain map dataset。本專案將資料隨 GitHub Pages 靜態網站部署，不呼叫 Google Maps、Mapbox 或任何外部地圖 API。

## 邊界口徑

Natural Earth 預設呈現 de facto（事實控制）邊界，並提供部分不同觀點的資料變體。P133 的底圖僅作教育性地圖視覺化與尺度比較，不能作為主權、法律、行政或測量判斷依據。後續若加入特定敏感地區的教學情境，必須將資料版本、口徑與說明顯示於介面。
