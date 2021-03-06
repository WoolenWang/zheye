# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
register_answer_comment = () ->
  $("a[id^=answer]").each (idx, ele) ->
    console.log(ele)
    ele = $(ele);
    question_id = ele.data('question-id')
    answer_id = ele.data('answer-id')
    answer_and_id = "answer" + answer_id;
    console.log(question_id)
    ele.click ->
      console.log("click")
      container = $("#"+answer_and_id + "_comment_container")
      if (container.length)
        container.toggle()
      else
        placeholder = $("#"+answer_and_id+"_comments_placeholder")
        answer_comment_box = $("<div />").load(Routes.question_answer_answer_comments_path(question_id, answer_id))
        new_answer_comment_box = $("<div />").load(Routes.new_question_answer_answer_comment_path(question_id, answer_id))
        container = $("<div />", {id: answer_and_id+"_comment_container"}).append(answer_comment_box).append(new_answer_comment_box)
        placeholder.append(container)

display_new_answer_box = () ->
  new_answer_box = $("#new_answer_box")
  if (new_answer_box.length && $('a[data-user-login='+new_answer_box.data('user-login')+']').length == 0)
    userlogin = new_answer_box.data('user-login')
    questionid = new_answer_box.data("question-id")
    new_answer_box.load(Routes.new_question_answer_path(
        questionid
    ),
     ->
       store = $.AMUI.store;
       if (store.enabled)
         d = store.get(userlogin + '-' + questionid)
         if (d)
           CKEDITOR.instances.answer_content.setData(d)
       setInterval(
         ->
           store.set(userlogin + '-' + questionid, CKEDITOR.instances.answer_content.getData())
           console.log('saved')
         , 10000
       )
    )
  else
    new_answer_box.html('')

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

upvote_btn = (e) ->
  target = $ e.target
  vote_id = target.data('id');
  $('input[type=text][data-vote-id='+vote_id+']').attr('value', if target.hasClass('am-success') then 0 else 1)
  $('form[data-id='+vote_id+']').submit()

downvote_btn = (e) ->
  target = $ e.target
  vote_id = target.data('id');
  $('input[type=text][data-vote-id='+vote_id+']').attr('value', if target.hasClass('am-success') then 0 else -1)
  $('form[data-id='+vote_id+']').submit()

register_vote = ->
  $('.upvote-btn').click upvote_btn
  $('.downvote-btn').click downvote_btn

work_after_answer = () ->
  register_answer_comment()
  display_new_answer_box()
  register_vote()
  
getSortParam = ->
  query = window.location.search.substring(1)
  raw_vars = query.split("&")
  
  sort = "sort=1"
  
  for v in raw_vars
    [key, val] = v.split("=")
    if (key == "sort")
      sort = "sort=" + decodeURIComponent(val)
      
  sort

$ ->
  answer_box = $("#answer_box")
  if (answer_box.length)
    answer_box.load(Routes.question_answers_path(
        answer_box.data("question-id")
        ),
      getSortParam(),
        work_after_answer
    )

  register_answer_comment()
  register_vote()


  question_comment_link = $("#question_comment_link")
  question_id = question_comment_link.data("question-id")

  if (question_comment_link.length)
    question_comment_link.click ->
      question_comment_container = $("#question_comment_container")
      if (question_comment_container.length)
        question_comment_container.toggle()
      else
        question_comment_box = $("<div />", {id: "question_comment_box"})
        question_comment_box.load(Routes.question_question_comments_path(question_id))
        new_question_comment_box = $("<div />", {id: "new_question_comment_box"})
        new_question_comment_box.load(Routes.new_question_question_comment_path(question_id))
        question_comment_container = $("<div />", {"id": "question_comment_container"}).append(
            question_comment_box
        ).append(
            new_question_comment_box
        )
        $("#question_comments_placeholder").append(question_comment_container)
