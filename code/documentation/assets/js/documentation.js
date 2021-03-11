
(function(){
    let dropdowns = document.querySelectorAll('.nav-dropdown');
    dropdowns.forEach(span => {
       let parent = span.closest('li');
       span.addEventListener('click', e =>{
           parent.classList.toggle('expanded');
       });
    });
}());