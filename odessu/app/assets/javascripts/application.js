// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require cable


$(document).ready(function() {
  setTimeout(function(){
    $('#alert').slideUp();
  }, 2000);

  setTimeout(function(){
    $('#notice').slideUp();
  }, 2000);

  $('.body_shape_img').on('click', function(){
    $('.body_shape_img').removeClass('body_shape_clicked').css('opacity', '1');
    $(this).addClass('body_shape_clicked').css('opacity', '0.3');
  })

  $('button.body_shape_save').on('click', function(e){
    // e.preventDefault();
    var bodyShape = $('.body_shape_clicked').attr('name');
    $.ajax({
      url: '/create_body_shape',
      method: 'post',
      data: {
        body_shape: bodyShape
      }
    })
  })

  $(".button_submit").on("click", function(e) {
    e.preventDefault();
    var issuesTop = [];
    var issuesBottom = [];
    var insecuritiesTop = [];
    var insecuritiesBottom = [];
    $(':checkbox:checked').each(function(i){
      if ($(this).attr('name')==="issue_top[]"){
        issuesTop.push($(this).val());
      }
      else if ($(this).attr('name')==="issue_bottom[]"){
        issuesBottom.push($(this).val());
      }
      else if ($(this).attr('name')==="insecurity_bottom[]"){
        insecuritiesBottom.push($(this).val());
      }
      else if ($(this).attr('name')==="insecurity_top[]"){
        insecuritiesTop.push($(this).val());
      }
    });
    $.ajax({
      url: '/update_issues',
      method: 'put',
      data: {
        issues_top: issuesTop, issues_bottom: issuesBottom,
        insecurities_top: insecuritiesTop, insecurities_bottom: insecuritiesBottom
      }
    }).done(function(){
      $(".form1 > form").submit();
    })
  })

  $('.filter').click(function(){
    var filter = $(this).html();
    $.ajax({
      url: '/products',
      method: "get",
      data: {
        filter: filter
      },
      dataType: 'json'
    }).done(function(data){
      var results = $("<div>").addClass("results-container").addClass('index');
      for(i=0; i < data.length; i++){
        var productId = data[i]['id'];
        var url = 'http://localhost:3000/products/' + productId;
        var link = $('<a>').attr('href', url);
        var filterResultContainer = $("<div>").addClass('filter-result');
        filterResultContainer.append($("<span>").html(data[i]["name"])).append($('<br>'));
        var imgSrc = data[i]['picture_src']
        var resultImage = $("<img>").attr('src', imgSrc).attr('height', "300").attr('width', "200");
        filterResultContainer.append(resultImage).append($('<br>'));
        filterResultContainer.append($("<span>").addClass('price-before').html(data[i]["pricebefore"]));
        filterResultContainer.append('&nbsp; &nbsp;').append($("<span>").html(data[i]["priceafter"]));
        (results.append(link.append(filterResultContainer))).append($('<br>')).append($('<br>'));
      }
      $('.index').replaceWith(results);
      })
    })

    $('#user_tops_store').change(function(){
      var storeName = $(this).val();
      $.ajax({
        url: '/profile_1',
        method: 'get',
        data:{
          store_name: storeName
        },
        dataType: 'JSON'
      }).done(function(data){
        $('#user_tops_size').empty();
        for(i=0; i < data.length; i++){
          $('#user_tops_size').append("<option>" + data[i] + "</option>")
        }
      })
    })

    $('#user_bottoms_store').change(function(){
      var storeName = $(this).val();
      $.ajax({
        url: '/profile_1',
        method: 'get',
        data:{
          store_name: storeName
        },
        dataType: 'JSON'
      }).done(function(data){
        $('#user_bottoms_size').empty();
        for(i=0; i < data.length; i++){
          $('#user_bottoms_size').append("<option>" + data[i] + "</option>")
        }
      })
    })


    $('body').delegate('.close-chat', 'click', function(){
      $('.messager').animate({right:"-1000px"}).removeClass('visible');
    })

    $('body').delegate('.messager-submit', 'click', function(e){
      e.preventDefault();
      // var messageSubmit = $('<div>', {class: 'campaign-message-submit', text: "Your message has successfully been sent!"});
      var message = $('.new_message textarea').last().val();

      $.ajax({
        url:'/messages',
        method: "POST",
        data:{
          body: message,
          receiver_id: 1
        }
      }).done(function(data){
        $('.new_message textarea').last().val('');
        $.ajax({
          url:'/messages/new',
          method: 'GET',
          data: {
            receiver_id: 1
          }
        }).done(function(data){
          $('.chat-content').html(data);
          $('.sendmessage').addClass('messager-submit');
          $('.sendmessage').removeClass('sendmessage');
          $('#conversation-body').scrollTop($('#conversation-body').prop("scrollHeight"));
        })
      })

    })
  })
