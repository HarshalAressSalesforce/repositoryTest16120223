public class emailController {
   public static void sendEmail() {
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
       string[] to = new string[] {'harshal.kulkarni@aressindia.net','anup.rojekar@aress.com','prosenjit.mahalanobis@aress.com'};
         
       email.setToAddresses(to);
       email.setSubject('Test Mail');         
        
       String body  = '<link href="https://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet" type="text/css">';
       body += '<script src="https://code.jquery.com/jquery-latest.min.js"></script>';
       body += '<script src="https://www.jqueryscript.net/demo/Simple-jQuery-Infinite-Carousel-Plugin-lbSlider/jquery.lbslider.js"></script>';
       body += '<script>jQuery( document ).ready(function() { jQuery(\'.slider\').lbSlider({ leftBtn: \'.sa-left\',    rightBtn: \'.sa-right\',    visible: 3,    autoPlay: true,    autoPlayDelay: 5})});</script>';  
       body +='<style>.slider-wrap {position: relative;margin: 50px auto;width: 520px;}.slider {position: relative;width: 450px;margin: auto;}ul {margin: 0;padding: 0;}ul li {list-style: none;text-align: center;}ul li span {display: inline-block;vertical-align: middle;width: 100px;height: 100px;background: black;}.slider-arrow {position: absolute;top: 40px;width: 20px;height: 20px;background: black;color: #fff;text-align: center;text-decoration: none;border-radius: 50%;}.sa-left {left: 10px;}.sa-right {right: 10px;}.black {background: black;}.red {background: red;}.green {background: green;}.blue {background: blue;}.yellow {background: yellow;}</style>';   
       body += '<div class="slider-wrap"><div class="slider"><ul><li> <span class="black"></span> </li><li> <span class="red"></span> </li><li> <span class="yellow"></span> </li><li> <span class="blue"></span> </li><li> <span class="green"></span> </li></ul></div><a href="#" class="slider-arrow sa-left">&lt;</a> <a href="#" class="slider-arrow sa-right">&gt;</a> </div>';
       body += 'Hello, <br/><br/>This is the test mail that you generated. <br/>';
       email.setHtmlBody(body);
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
   }
   
}