window.onload = function() 
                        {
                            document.getElementById('tab'+currentTab  +'Id').focus();
                            document.getElementById(currentTab).style.display = "block";
							clickTab(currentTab);
							 
							
                        };
						
                        function toggle(source) 
                        {
                            var checkboxes = document.querySelectorAll('input[type="checkbox"]');
                            for (var i = 0; i < checkboxes.length; i++) 
                            {
                                if (checkboxes[i] != source)
                                    checkboxes[i].checked = source.checked;
                            }
                        }
                        
						/*function clickTab(cityName) {
							var i;
							var x = document.getElementsByClassName("tabcontent");
							for (i = 0; i < x.length; i++) {
							   x[i].style.display = "none";  
							}
							document.getElementById(cityName).style.display = "block";  
						}*/
						
						function clickTab(cityName) 
						{
							var i, tabcontent, tablinks;
							tabcontent = document.getElementsByClassName("tabcontent");
							for (i = 0; i < tabcontent.length; i++) 
							{
								tabcontent[i].style.display = "none";
							}
							makeActivTab(cityName);
						}
						
						
						function makeActivTab(cityName) {
							var i, tabcontent, tablinks; 
							tablinks = document.getElementsByClassName("tablinks");
							for (i = 0; i < tablinks.length; i++) 
							{
								tablinks[i].className = tablinks[i].className.replace(" recipient-tabs active", "");
							}
							document.getElementById(cityName).style.display = "block";
							//evt.currentTarget.className += " recipient-tabs active";
							 document.getElementById('tab'+cityName  +'Id').className += " recipient-tabs active";
							
						}