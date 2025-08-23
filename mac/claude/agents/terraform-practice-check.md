---
description: "Future Tech BlogのTerraformガイドライン, awslabs.terraform-mcp-serverに基づくコードチェック"
allowed-tools: WebFetch, Read, Bash, Glob, Grep, mcp__awslabs_terraform-mcp-server__*, ListMcpResourcesTool, ReadMcpResourceTool
---

Claude Codeを用いてTerraformコードのベストプラクティスチェックを行います。

## 概要

Future Tech BlogのTerraformガイドライン（https://future-architect.github.io/articles/20250409a/）に基づいて、Terraformコードの品質とセキュリティをチェックするカスタムスラッシュコマンドです。実行時に最新のガイドラインを取得し、awslabs.terraform-mcp-serverを活用して包括的な分析を実行します。

## 実行手順

### 1. 最新ガイドライン取得フェーズ

まず、Future Tech Blogから最新のTerraformガイドラインを取得します：

```
WebFetch: https://future-architect.github.io/articles/20250409a/
```

記事内に詳細なガイドラインへのリンクがある場合は、それらも取得して統合的な分析を行います。

### 2. Terraformコード分析フェーズ

現在のディレクトリまたは指定されたパスのTerraformファイルを特定・分析します：

- `Glob: **/*.tf` でTerraformファイルを検索
- `Read` で各ファイルの内容を確認
- ディレクトリ構造の分析

### 3. ベストプラクティスチェックフェーズ

取得したFuture Tech Blogのガイドラインに基づいて、以下を実行：

- 記事から抽出したチェック項目を体系的に整理
- 各チェック項目に対してTerraformコードを検証
- ガイドラインの更新内容を自動的に反映
- 記事内のリンク先ドキュメントも参照（存在する場合）

注：チェック項目は記事の内容により動的に決定されるため、最新のベストプラクティスが常に適用されます。

### 4. MCP Server活用フェーズ

awslabs.terraform-mcp-serverを使用して技術的検証を実行します。
以下の機能を状況に応じて活用：

#### 基本検証
- **構文チェック**: Terraformコードの構文検証（ExecuteTerraformCommand等）
- **セキュリティスキャン**: Checkovによる脆弱性検出（RunCheckovScan等）

#### ベストプラクティス確認
- **AWSベストプラクティス**: terraform_aws_best_practicesリソースを参照
- **開発ワークフロー**: terraform_development_workflowに従った検証

#### モジュール・ドキュメント検索
- **AWS-IAモジュール**: 使用中のAWSサービスに適したモジュールを推奨
- **プロバイダードキュメント**: AWCCプロバイダー優先、必要に応じてAWSプロバイダー

注：具体的な関数名やパラメータは、MCPサーバーのバージョンやTerraformプロジェクトの構成により動的に決定されます。

### 5. 統合レポート生成フェーズ

チェック結果を以下の形式でレポート：

#### ✅ 準拠項目
- Future Tech Blogガイドラインに準拠している項目
- 正しく設定されているセキュリティ項目
- 適切に使用されているAWSリソース

#### ⚠️ 改善推奨項目
- ガイドラインからの軽微な逸脱
- パフォーマンス向上の提案
- より良いモジュールの推奨

#### 🚨 要修正項目
- セキュリティリスク
- 構文エラー・設定ミス
- ガイドライン違反の重要項目

#### 💡 提案事項
- AWS-IAモジュールの活用提案
- コード構造の改善案
- 運用効率向上のアドバイス

## 注意事項

- Terraformがインストールされている環境で実行
- AWSプロバイダーを使用しているプロジェクトで最適化されています
- 大規模なプロジェクトでは実行に時間がかかる場合があります

このコマンドにより、Future Tech Blogの最新ガイドラインとAWSベストプラクティスに準拠した、高品質で安全なTerraformコードの維持が可能になります。