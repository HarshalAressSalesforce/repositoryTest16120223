 

window.ExampleJS = ( function() {
    return {
        printDiv: function() {
			console.log(document.getElementById('printDiv'));
            var divContents = document.getElementById('printDiv').innerHTML; 
			 console.log(divContents);
			 /*var printWindow = window.open('', '', 'height=200,width=400'); 
			 printWindow.document.write('<html><head><title>Print DIV Content</title>'); 
			 printWindow.document.write('</head><body >'); 
			 printWindow.document.write(divContents); 
			 printWindow.document.write('</body></html>'); 
			 printWindow.document.close(); 
			 printWindow.print(); */
        }
    };
}());