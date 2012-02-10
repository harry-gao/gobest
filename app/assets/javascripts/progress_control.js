/**
 * Created by JetBrains RubyMine.
 * User: hgao
 * Date: 28/01/12
 * Time: 3:48 PM
 * To change this template use File | Settings | File Templates.
 */
$(function(){
    $('#finish_today').click(function(){
        $.get('/home/mark_finished', {days: '0'}, function(){
            //call back after make today as finished
            $('#action').html("congratulations")
        })
    })
})