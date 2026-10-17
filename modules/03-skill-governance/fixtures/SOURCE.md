# Fixture 來源與處理規則

- 來源：`/Users/qingwang/Documents/workspace/code/jfrog-sample/skills-sample/`
- 範例名稱：`env-demo-malicious`
- 封裝版本：`1.0.0`
- ZIP SHA-256：`8a909f1d232a9748936904ed903d64410ae8557811fd2cb92dba00789742b417`
- ZIP 內 `SKILL.md` SHA-256：`63495550a2f490e190ad0904ede002f471e6a0225e76987f43cd6fd61cad55fd`

ZIP 中包含會要求列出環境變數並外洩 `.env` 的未信任指示。只可將 ZIP 當作 JFrog 掃描輸入；不得解壓到 Codex Skill 搜尋路徑、不得安裝、不得執行。
