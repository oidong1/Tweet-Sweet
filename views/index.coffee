section ->
   if @id and @content isnt 404
      p img src:'/images/result.png'
      br img src:'http://api.twitter.com/1/users/profile_image?screen_name='+@id+'&size=bigger'
      h2 '@'+@id

      #judge
      total = 0
      reg = new RegExp('[!-/:-@[-`{-~ ]','g')
      regx = new RegExp('@[a-z0-9_]+','ig')
      reg1 = new RegExp('[ゃゅょらるω・]','g')
      reg2 = new RegExp('[ぁ-ん…・、。！？]','g')
      for item in @content
         item.text = item.text.replace(regx,'')
         item.text = item.text.replace(reg,'')
         point = item.text.match(reg1)
         unless point == null
            point = point.length * 100
            total += point
         point = item.text.match(reg2)
         unless point == null
            point = point.length/item.text.length * 100
            total += point
      total = Math.round(total / (@content.length*30))
      #hash-data
      div id:'result', ->
         h3 'あなたのツイートは…'
         mes = ''
         imgurl = ''
         switch total
            when 0
               mes = 'キャラメルのような、甘いけれど少し固いツイートです。'
               imgurl = '/images/food-138.jpg'
            when 1
               mes = 'モンブランのように、少し変わっていて個性的なツイートです。'
               imgurl = '/images/food-149.jpg'
            when 2
               mes = 'マカロンのように、色とりどりで様々なツイートです。'
               imgurl = '/images/goods10.jpg'
            when 3
               mes = 'チョコレートのような、少しビターで大人のツイートです。'
               imgurl = '/images/foods_2.jpg'
            when 4
               mes = 'イチゴタルトのように、甘酸っぱくて爽やかなツイートです。'
               imgurl = '/images/foods_28_4.jpg'
            when 5
               mes = 'キャンディのように、小さくて甘いかわいいツイートです。'
               imgurl = '/images/food-471a.jpeg'
            when 6
               mes = 'クッキーのような、サクサクでカジュアルなツイートです。'
               imgurl = '/images/1_1.jpg'
            when 7
               mes = 'ゼリーのように、ぷるぷるしていてぷにぷになツイートです。'
               imgurl = '/images/food-333.jpeg '
            when 8
               mes = 'ドーナツのように、甘々でふわふわなツイートです！'
               imgurl = '/images/food-149.jpg'
            else
               mes = 'マシュマロのように、ゆるゆるふわふわしているツイートです！'
               imgurl = '/images/food-352.jpg'
         br img src:imgurl, id:'result'
         h3 mes
         a href:'https://twitter.com/intent/tweet?text=.@'+@id+'のツイートは'+mes+' http://sweet.yuru.in #twsw', ->
            p img src:'/images/post.png'
   else if @content==404
      h3 'ユーザーが存在しません。'
   else
      br img src:'/images/about.png'
      br text '最新の20件のツイートから、'
      text 'その人のツイートがどんなスイーツと似ているのかを調べる、新しい形のサービスです。'
      p class:'opt', ->
         img src:'/images/1.jpg'
         img src:'/images/2.jpg'
         img src:'/images/3.jpg'

section ->
   if @session.user_profile
      img src:'/images/twitter.png'
      form class:'input', method:'POST', action:'/', ->
         div ->
            text '@'
            input type:'text', class:'screen_name', name:'screen_name', maxlength:15
            input type:'image', class:'button', value:'調べる！', src:"/images/button.png"
      p a href: "/signout", -> "認証を解除する"
   else
      p img src:'/images/login.png'
      p a href: "/auth/twitter" ,-> p img src: "images/sign-in-with-twitter-l.png"
section ->
   script src: 'http://widgets.twimg.com/j/2/widget.js'
   script 'new TWTR.Widget({\n   version: 2,\n   type: \'search\',\n   search: \'#twsw\',\n   interval: 30000,\n   title: \'\',\n   subject: \'\',\n   width: "auto",\n   height: 200,\n   theme: {\n      shell: {\n         background: \'#fbcfcf\',\n         color: \'#ffffff\'\n      },\n      tweets: {\n         background: \'#ffffff\',\n         color: \'#eb5591\',\n         links: \'#452c0a\'\n      }\n   },\n   features: {\n      scrollbar: false,\n      loop: true,\n      live: true,\n      behavior: \'default\'\n   }\n}).render().start();'
