$(function (){
  $('#viz_form').submit(function(ev){
    //this happens if form is submitted
    //prevent the default behavior of a form (it should do nothing in our case)
    ev.preventDefault();

    //send an ajax request to our action
    $.ajax({
      url: "/follower_viz",
      //serialize the form and use it as data for our ajax request
      data: $(this).serialize(),
      //the type of data we are expecting back from server, could be json too
      dataType: "html",
      success: function(data) {
        //if our ajax request is successful, replace the content of our viz div with the response data
        $('#viz').html(data);
      }
    });

    //show the link to the repo_viz (don't forget: we are still in the submit event!)
    $('#viz_link').append($("#viz_form input:first").val());
    $('#viz_p').show();
  });

  $('#viz_link').click(function(ev){
    //this happens if we click our new shiny link with the submitted username in it

    //do you remember?! :)
    ev.preventDefault();

    $.ajax({
      url: "/repo_viz",
      data: "user="+$("#viz_form input:first").val(),
      dataType: "html",
      success: function(data) {
        $('#viz').html(data);
      }
    });

  });
});