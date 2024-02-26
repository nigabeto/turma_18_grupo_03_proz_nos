// Selecionar todos os links com a classe 'adicionar-item'
const links = document.querySelectorAll('.adicionar-item');

// Adicionar evento de clique para cada link
links.forEach(link => {
    link.addEventListener('click', function(event) {
        event.preventDefault(); // Impedir o comportamento padrão do link

        const item = this.getAttribute('data-item'); // Obter o item a ser adicionado
        adicionarAoCarrinho(item); // Adicionar o item ao carrinho
    });
});

// Função para adicionar o item ao carrinho e exibir uma mensagem
function adicionarAoCarrinho(item) {
    const mensagem = `Seu pedido foi adicionado ao carrinho: ${item}`;
    alert(mensagem);
}