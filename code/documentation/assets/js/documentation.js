
(function(){
    let dropdowns = document.querySelectorAll('.nav-dropdown');
    dropdowns.forEach(span => {
       let parent = span.closest('li');
       span.addEventListener('click', e =>{
           parent.classList.toggle('expanded');
       });
    });
    document.querySelectorAll('details').forEach(details => {
       details.addEventListener('toggle', e => {
         if (details.classList.contains('clicked')){
            return;
          }
          if (details.open){
           details.querySelectorAll('img').forEach(img => {
              img.src = img.getAttribute('data-src'); 
           });
            details.classList.add('clicked');
          }
       });
    });
    const dialog = getDialogEl();
    console.log(dialog);
    const dialog_content = dialog.querySelector('#dialog-content');
    document.querySelectorAll('img').forEach(img => {
        img.addEventListener('click', e=> {
            dialog_content.innerHTML = '';
        dialog_content.appendChild(img.cloneNode());
        dialog.showModal();
  });
});
}());

function getDialogEl(){
    if (!document.querySelector('dialog')){
       let frag = `<dialog><form method="dialog"><button name="close">X</button></form><div id="dialog-content"></div></dialog>`;
       document.querySelector('body').insertAdjacentHTML('beforeend', frag);
    }
    return document.querySelector('dialog');
}