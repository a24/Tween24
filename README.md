Tween24
=======

Tween24 is Tween library for ActionScript 3

**lastest version:** 2.0.1

[http://package.a24.cat/tween24/](http://package.a24.cat/tween24/)

Introduction
--------------------------

「思いついた演出をすぐに実装したい」
「頭の中ではできているのに、コーディングするのが面倒」

と、感じることはありませんか？

Flashコンテンツを作る上で欠かせないトゥイーンライブラリ。TweenerやBeTweenAS3など、使ったことのある方も多いと思います。私自身、使い慣れているという点でTweenerをよく使っていましたが、いくつかの不満点がありました。

* 機能が少ない。
* トゥイーンを単体でしか再生できない。
* フィルタ系のプロパティを扱うのが面倒。
* transitionをtransitoinにタイプミスする。
* そもそもタイピングするのが面倒。

などなど

これらの点を解消するために、新しいライブラリ「Tween24」を開発しました。

[download source code](https://github.com/a24/Tween24/archive/master.zip)

メソッドチェーンで、新感覚コーディング
----------------------------------------

```as3
// 例）Tweenerの場合
FilterShortcuts.init();
Tweener.addTween(target, { time:1, transition:"linear", x:100, y:200, _Blur_blurX:16, _Blur_blurY:16 } );

// 例）Tween24の場合
Tween24.tween(target, 1, Ease24._Linear).xy(100, 200).blur(16, 16).play();
```

メソッドチェーンで指定することにより、以下のようなメリットがあります。

* エディタのコード補完をフル活用できるので、タイピング数を劇的に減らします。
* 補完機能によりプロパティ名などを覚える必要がなく、タイプミスもなくなります。
* ASDocなどのドキュメントを読まなくても、補完リストで全ての機能を大体把握することができます。
* 一つのメソッドで複数のプロパティを設定できるので、コードを簡潔に書くことができます。
