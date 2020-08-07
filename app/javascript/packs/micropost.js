const IMAGE_MAX_SIZE = 5

$('#micropost_image').bind('change', function() {
  var size_in_megabytes = this.files[0].size/1024/1024; 
  if (size_in_megabytes > IMAGE_MAX_SIZE) {
    alert(t('.oversize_alert'));
  }
}); 
