function onNameFocus() {
  document.getElementById("empname").setAttribute("placeholder", "");
}

function onNameBlur() {
  document
    .getElementById("empname")
    .setAttribute("placeholder", "Имя сотрудника");
}

function checkNum() {
  var str = document.getElementById("empnum").value;
  if (!/^\d+$/.test(str)) {
    alert("Номер может содержать только цифры");
  }
}

function restoreData() {
  var table = document.getElementById("emptable");
  for (var row of table.rows) {
    row.style.display = "";
  }
}

function deleteConfirm(item) {
  var del = confirm("Вы хотите удолить??((");
  if (del) {
    document.getElementById(item).parentElement.parentElement.style.display =
      "none";
  }
}

function sendText() {
  var str = document.getElementById("empname").value;
  localStorage.setItem('msg', str);
  var opened = window.open(
    "./newemp.html",
    "file:///C:/IdeaProjects/javaeelabz/src/html/newemp.html"
  );
  
}
