window.onload = function(event) {
    var inp = localStorage.getItem('msg');
    document.getElementById('newname').value = inp;
    localStorage.removeItem('msg');
}