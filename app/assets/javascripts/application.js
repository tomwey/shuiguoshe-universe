// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.countdown.min
//= require turbolinks
//= require jquery.chosen
//= require_tree .

$(function(){
    $(window).scroll(function(){
    var top=$(window).scrollTop();
    if( top>200 ){
      $("#scrolltop").fadeIn();
    } else {
      $("#scrolltop").fadeOut();
    }
});
 
$("#scrolltop").click(function(){
    $("html,body").animate({scrollTop:0});
    });
});

$(function() {
  $(".countdown").each(function(idx, item) {
    var $item = $(item);
    var name = '剩余';
    // $item.countdown($item.data('countdown'), function(event) {
    //   $(this).html(event.strftime(name + '%D天%H小时%M分%S秒'));
    // });
    $item.countdown($item.data('countdown'))
    .on('update.countdown', function(event) {
      $(this).html(event.strftime(name + '%D天%H小时%M分%S秒'));
    })
    .on('finish.countdown', function(event) {
      $(this).html(event.strftime(name + '00天00小时00分00秒'));
      $(".price-extra " + "#item-" + $item.data('id')).attr("class", "btn btn-sm btn-warning").attr("disabled", true).text("活动已结束");
      
    });
    
  });
});

$(document).ready(function() {
  $("select").chosen({"search_contains": true, "no_results_text":"没有找到", "placeholder_text_single":"请选择小区"});
});

$("#u-cart-result, #cart-panel").on("mouseover", function() {
  $(".hover-mask").show();
  $("#cart-panel").show();
  $("#u-cart-result").addClass("cart-result-hover");
});
$("#u-cart-result, #cart-panel").on("mouseout", function() {
  $(".hover-mask").hide();
  $("#cart-panel").hide();
  $('#u-cart-result').removeClass("cart-result-hover");
});

$("#u-wechat, #wechat-panel").on("mouseover", function() {
  $(".hover-mask").show();
  $("#wechat-panel").show();
  $("#u-wechat").addClass("link-text-hover");
});

$("#u-wechat, #wechat-panel").on("mouseout", function() {
  $(".hover-mask").hide();
  $("#wechat-panel").hide();
  $("#u-wechat").removeClass("link-text-hover");
});
