<?php

file_put_contents("images/".md5(time()).".jpg", base64_decode($_POST['imageData']));


