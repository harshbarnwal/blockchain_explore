var crypto = require('crypto');
var data = "The Project Gutenberg eBook of War and Peace, by Leo Tolstoy This eBook is for the use of anyone anywhere in the United States and most other parts of the world at no cost and with almost no restrictions whatsoever. You may copy it, give it away or re-use it under the terms of the Project Gutenberxcxcg License included with this eBook or online at www.gutenberg.org. If you are not located in the United States, you will have to check the laws of the country where you are located before using this eBook. Title: War and Peace Author: Leo Tolstoy Translators: Louiseand Aylmer Maude Release Date: April, 2001 [eBook #2600]";
var hash = crypto.createHash(/*'md5'*/'sha256').update(data).digest('hex');
console.log(hash); 
