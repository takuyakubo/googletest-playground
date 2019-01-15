# googletest-playground

このrepositoryはgoogletestを試すためのものです。
[tjun/googletest-circleci](https://github.com/tjun/googletest-circleci)を参考にしています。

## 実行の仕方
### 環境
以下の環境で実行を確認しています。

- MacOS 10.12.6
- clang++ Apple LLVM version 9.0.0 (clang-900.0.39.2) 

### googletestの取得
```
git submodule init
git submodule update
```
### ビルド

```
make
make test
```

### テスト実行

```
make test-exec
```
