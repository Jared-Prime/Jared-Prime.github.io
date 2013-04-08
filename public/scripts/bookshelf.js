$(document).ready(function(){

  if ($("#bookshelf") && $("#links")) {

    jQuery.getJSON("/bitly", function(data){
      var bundles = ["<h3>Reading List (via Bitly)</h3>"];
      $.each(data, function(i,bundle) {
        console.log(bundle);
        bundles.push("<ul>" + bundle['title']);
        for (var i = 0; i < bundle['links'].length; i++) {
          var item   = bundle['links'][i]
              ,link  = item['link']
              ,title = item['title']
              ,desc  = item['comments'];
          if ( title.match(/GitHub/) ) {
            title = title
                    //.replace(/GitHub/,"")
                    .replace(/\/?[A-Za-z]+/,'')
                    .replace(/\//,'')
                    .replace(/ · /,'');
          }
          if ( desc === undefined || desc.length < 1 ) {
            desc = '';
          } else {
            desc = " &mdash; " + desc[0]['text'];
          }
          bundles.push("<li><a href=\"" + link + "\">" + title + "</a>" + desc + "</li>");
        };
        bundles.push("</ul>");
      });
      $("#links").html(bundles.join(''))
    });

  };

});
