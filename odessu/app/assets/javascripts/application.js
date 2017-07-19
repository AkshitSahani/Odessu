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
        var filterResultContainer = $("<div>").addClass('filter-result');
        filterResultContainer.append($("<span>").html(data[i]["name"]));
        var imgSrc = data[i]['picture_src']
        var resultImage = $("<img>").attr('src', imgSrc).attr('height', "300").attr('width', "200");
        filterResultContainer.append(resultImage);
        filterResultContainer.append($("<span>").html(data[i]["pricebefore"]));
        filterResultContainer.append($("<span>").html(data[i]["priceafter"]));
        results.append(filterResultContainer);
      }
      // var replace = $(".row")[1]
      $('.index').replaceWith(results);
      // $("body").append(results);
      })
    })

  })
