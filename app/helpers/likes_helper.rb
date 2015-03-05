module LikesHelper
  # 收藏功能
  def likeable_tag(likeable)
    liked = false
    if current_user
      if Like.where(likeable_type: likeable.class, likeable_id: likeable.id, user_id: current_user.id).count > 0
        liked = true
      end
    end
    
    if liked
      link_to("取消收藏", "#", title: "取消收藏", rel: "twipsy", 
              'data-state' => 'liked', 'data-type' => likeable.class, 'data-id' => likeable.id,
              class: "btn btn-danger", onclick: "return App.likeable(this);")
    else
      link_to("收藏", "#", title: "收藏", rel: "twipsy",
              'data-state' => '', 'data-type' => likeable.class, 'data-id' => likeable.id,
              class: "btn btn-warning", onclick: "return App.likeable(this);")
    end
  end
end