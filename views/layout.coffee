doctype 5
html lang:'ja',->
   head ->
      title 'Tweet*Sweet'
      meta charset: 'utf-8'
      meta name:'description', content:'Twitterでどれだけ「ゆるふわ」なのかを知ることのできるサービスです。'
      link rel:'stylesheet', href:'/stylesheets/style.css'
      script src: 'http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js'
      script src: 'http://html5shiv.googlecode.com/svn/trunk/html5.js'
   body ->
      header ->
      a href: '/', ->
         img src: '/images/logo.png'
      @body
   p ->
      text 'developed by @'
      a href:'http://twitter.com/oidong1', -> 'oidong1'
   text 'thanks!: '
   a href:'http://www.geocities.jp/cotcotbiz/sp/', -> 'Spica*port'
   text ' / '
   a href:'http://sweety.chips.jp/',-> 'Sweety'
   text ' / '
   a href:'http://hibana.rgr.jp/', -> ' フリー素材 * ヒバナ'
