# Retro RPG Recomp

Motor nativo e orientado a dados para preservar RPGs clássicos de Game Boy.
O primeiro adaptador em desenvolvimento é para **SD Gundam Gaiden: Lacroan'
Heroes (Japan)**.

## Princípios

- nenhuma ROM, save ou mídia comercial é distribuída pelo projeto;
- o jogador fornece uma ROM legalmente obtida;
- a ROM é validada por hash antes de qualquer importação;
- dados derivados são gerados localmente e permanecem privados;
- o motor reimplementa comportamento, renderização e regras sem emular o
  processador do Game Boy.

## Fonte canônica aceita

| Campo | Valor |
| --- | --- |
| Título interno | `GB LACROANHERO 1` |
| Plataforma | Game Boy (DMG) |
| Região | Japan |
| Revisão | 0 |
| Mapper | MBC2 + Battery |
| Tamanho | 131072 bytes |
| CRC32 | `c9dbba10` |
| MD5 | `5c815764df1d3c04d99a9bc5b298aa2c` |
| SHA-1 | `bc598168a70bbbc1b89b3de13086ec89e8ce9ded` |
| SHA-256 | `fdbf98df05d2af9f81b2ae09b06c651987d5eb92d222758c2281b631077c8f5a` |

## Executar o Gate 0

Requer Python 3.10 ou superior. A ROM fica fora do repositório:

```powershell
python tools/rominfo.py "C:\caminho\SD Gundam Gaiden - Lacroan' Heroes (Japan).gb"
python -m unittest discover -s tests -v
```

Para validar os testes de integração com a ROM:

```powershell
$env:LACROAN_ROM="C:\caminho\SD Gundam Gaiden - Lacroan' Heroes (Japan).gb"
python -m unittest discover -s tests -v
```

## Executar o protótipo

Requer [LÖVE 11.5](https://love2d.org/). Execute `love .` e arraste a ROM
canônica para a janela. A versão inicial valida o arquivo e exibe os metadados
do cartucho. A ROM não é copiada para o diretório do projeto.

## Estado

- [x] Gate 0: identificação e fingerprint da ROM
- [x] Validador estático de cabeçalho e checksums
- [x] Leitor de bancos de 16 KiB
- [x] Decodificador básico de tiles 2bpp
- [ ] Gate 1: localizar e renderizar o primeiro mapa
- [ ] Gate 2: movimentação e colisões
- [ ] Gate 3: diálogo e transição entre mapas

## Propriedade intelectual

Este projeto não é afiliado à Bandai, Sunrise, Nintendo ou aos demais
detentores de direitos. Gundam e os recursos do jogo original pertencem aos
seus respectivos proprietários. Nenhum conteúdo extraído deve ser publicado.

