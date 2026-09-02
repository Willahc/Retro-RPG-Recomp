# Gate 0 — Identificação da ROM

## Resultado

**PASS**

A fonte privada de desenvolvimento corresponde ao dump catalogado de
`SD Gundam Gaiden - Lacroan' Heroes (Japan)`, revisão 0.

## Evidências

- tamanho exato: 131072 bytes;
- header Nintendo válido;
- checksum do header: `0x05`, válido;
- checksum global: `0x1B3C`, válido;
- título interno: `GB LACROANHERO 1`;
- cartridge type: `0x06` (`MBC2+BATTERY`);
- ROM size code: `0x02` (128 KiB);
- oito bancos de 16 KiB;
- hashes CRC32, MD5, SHA-1 e SHA-256 registrados no manifesto;
- inspeção 2bpp inicial encontrou blocos gráficos reconhecíveis nos bancos 2
  e 6.

## Regras de governança

1. A ROM nunca será commitada, publicada ou empacotada.
2. Todo dado extraído permanece em diretório ignorado pelo Git.
3. O importador aceita somente fingerprints explicitamente governados.
4. Qualquer nova revisão da ROM exige um novo manifesto e novo Gate 0.
5. Fixtures públicas de teste devem ser sintéticas e livres de conteúdo do
   jogo original.

## Próximo gate

Gate 1: localizar os dados do primeiro mapa, documentar seus offsets e
renderizá-lo a partir da ROM validada.

