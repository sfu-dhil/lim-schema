
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
    fetch('json/typeahead.json')
        .then(response => response.json())
        .then(json => {
        const entries = Object.entries(json);    
        const searchInput = document.querySelector('nav.searchBar > input');
        const resultsDiv = document.createElement('div');
        const clear = () => {
           resultsDiv.innerHTML = ''; 
        }
        const typeahead = (value) => {
            clear();
            let valRex = new RegExp(value, 'ig');
            let results = entries.filter(([uri, title]) => {
                 return valRex.test(title);
            });
               let orderedResults = results.sort((a, b) => {
                    return a[0].length - b[0].length  
                });
                let resultsEntries = orderedResults.map(([uri, title]) => {
                    return `<div class="result"><a href="${uri}">${title}</a></div>`;   
                }).join('');
                resultsDiv.insertAdjacentHTML('beforeend', resultsEntries);  
        }
        
        resultsDiv.classList.add('results');
        searchInput.insertAdjacentElement('afterend', resultsDiv);
        searchInput.addEventListener('focus', () => {
        });
        
        searchInput.addEventListener('keyup', ({key}) => {
            let value = searchInput.value;
            if (value.length < 3){
                if (value.length == 0){
                    clear();
                }
                return;
            }
            typeahead(value);
          
            if (key == 'Enter'){
                if(!searchInput.reportValidity()){
                    return;
                }
            window.location.href = 'index.html?q=' + value;
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