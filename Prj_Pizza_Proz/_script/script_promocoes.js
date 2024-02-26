/**
 * Definição da quantidade de elementos div#promocoes
 */
const quantidade = document.querySelectorAll('div#promocoes ul').length;

/**
 * Calculo do limite até onde o carrossel pode andar para esquerda, considerando css div#promocoes (largura 300 + margem 2 * 15 + borda 2*1 + 4 de segurança
 */
const limite = (quantidade * 336) * -1;

/**
 * Definição do tamanho da largura do elemento div#promocao-centro, conforme css div#promocao-centro - max-width: 1010 px
 */
const tam_largura = document.querySelector('section#promocao div#promocao-centro').offsetWidth;

/**
 * Definindo a largura do elemento div#promocoes através do DOM
 */
document.querySelector('div#promocoes').style.width = (limite * -1) + 'px';

/**
 * Função para movimentaçao com a seta para direita
 */
document.querySelector('div#promocao-direita').addEventListener('click', function () {
    let posicao_atual = document.querySelector('div#promocoes').offsetLeft;//Posicão atual esqueda
    let nova_posicao = posicao_atual - tam_largura;// Posicão para onde vai a esquerda
    if (limite < posicao_atual - tam_largura) { //Limitação da movimentação (Soma de valores negativos)
        document.querySelector('div#promocoes').style.transition = 'left 1s ease'; //Transição lenta em 1s
        document.querySelector('div#promocoes').style.left = nova_posicao + 'px'; //Assume nova posição
    }

    if (limite > (nova_posicao - tam_largura)) { // Limitação de ultima posição
        document.querySelector('div#promocao-direita ion-icon').style.opacity = 0.5; //Alterar a opacidade
        document.querySelector('div#promocao-direita ion-icon').style.cursor = 'not-allowed'; //Bloquear cursor direita
    }

    document.querySelector('div#promocao-esquerda ion-icon').style.opacity = 1; //Define opacidade enquanto houver elementos a direita
    document.querySelector('div#promocao-esquerda ion-icon').style.cursor = 'pointer';//Habilita cursor pinter enquanto houver elementos a direita
});

/**
 * Função para movimentaçao com a seta para esquerda
 */
document.querySelector('div#promocao-esquerda').addEventListener('click', function () {
    let posicao_atual = document.querySelector('div#promocoes').offsetLeft;
    let nova_posicao = posicao_atual + tam_largura; //Posicão para onde vai a direta
    if (posicao_atual + tam_largura <= 0) { //Limitação da movimentação (Soma de valor negativo + positivo)
        document.querySelector('div#promocoes').style.transition = 'left 1s ease';//Transição lenta em 1s
        document.querySelector('div#promocoes').style.left = nova_posicao + 'px'; //Assume nova posição
    }

    if (nova_posicao === 0) { // Limitação de primeira posição
        document.querySelector('div#promocao-esquerda ion-icon').style.opacity = 0.5; //Alterar a opacidade
        document.querySelector('div#promocao-esquerda ion-icon').style.cursor = 'not-allowed'; //Bloquear cursor esquerda
    }
    document.querySelector('div#promocao-direita ion-icon').style.opacity = 1;//Define opacidade enquanto houver elementos a esquerda
    document.querySelector('div#promocao-direita ion-icon').style.cursor = 'pointer';//Habilita cursor pinter enquanto houver elementos a esquerda
});