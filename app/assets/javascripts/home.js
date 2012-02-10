$(function(){
    bindMenu();
    bindButtons();
});



function bindMenu()
{
    $('.page-header > ul > li').click(function(event, targetRoute){
        event.preventDefault();
        $('.page-header > ul > li[class="active"]').removeClass("active");
        $(event.currentTarget).addClass("active");
        targetRoute = targetRoute == undefined ? event.target["href"] : targetRoute;
        $.get(targetRoute, function(response){
            feedContent(response);
        });
    });
}

function bindButtons()
{
    $('#create').click(function(){
         $.get("/home/create", function(response){
            feedContent(response)
        });
    });

    $('#choosehabit').click(function(){
         $('#hothabits').trigger('click', $("#hothabits a").attr("href"));
    });
}


function feedContent(content)
{
     $('#status').html(content);
     bindButtons();
}