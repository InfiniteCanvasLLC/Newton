//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require creative/cbpAnimatedHeader
//= require creative/classie
//= require creative/jquery.easing.min
//= require creative/jquery.fittext
//= require_self

$(document).ready(function(){

  (function($) {
      "use strict"; // Start of use strict

      // jQuery for page scrolling feature - requires jQuery Easing plugin
      $('a.page-scroll').bind('click', function(event) {
          var $anchor = $(this);
          $('html, body').stop().animate({
              scrollTop: ($($anchor.attr('href')).offset().top - 50)
          }, 1250, 'easeInOutExpo');
          event.preventDefault();
      });

      // Highlight the top nav as scrolling occurs
      $('body').scrollspy({
          target: '.navbar-fixed-top',
          offset: 51
      })

      // Fit Text Plugin for Main Header
      $("h1").fitText(
          1.2, {
              minFontSize: '35px',
              maxFontSize: '65px'
          }
      );

      // Offset for Main Navigation
      $('#mainNav').affix({
          offset: {
              top: 100
          }
      })

  })(jQuery); // End of use strict

})
