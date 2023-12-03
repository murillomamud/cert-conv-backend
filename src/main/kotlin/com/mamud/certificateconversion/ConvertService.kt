package com.mamud.certificateconversion

import org.bouncycastle.openssl.jcajce.JcaPEMWriter
import org.bouncycastle.util.io.pem.PemObject
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.StringWriter
import java.security.KeyStore
import java.security.Security
import java.util.zip.ZipOutputStream

@Service
class ConvertService() {

    fun convertCertificate(file: MultipartFile, password: String): ByteArray {
        val pfx = file.bytes;

        Security.addProvider(org.bouncycastle.jce.provider.BouncyCastleProvider())
        val ks = KeyStore.getInstance("PKCS12");
        ks.load(pfx.inputStream(), password.toCharArray());
        val alias = ks.aliases().toList().firstOrNull() ?: throw InvalidFileException("Invalid file")

        val privateKey = ks.getKey(alias, password.toCharArray()) ?: throw InvalidFileException("Invalid file")

        val cert = ks.getCertificate(alias) ?: throw InvalidFileException("Invalid file")

        val privateKeyWriter = StringWriter();
        val pemPrivateKeyWriter = JcaPEMWriter(privateKeyWriter);
        pemPrivateKeyWriter.writeObject(privateKey);
        pemPrivateKeyWriter.close();

        val certWriter = StringWriter();
        val pemCertWriter = JcaPEMWriter(certWriter);
        pemCertWriter.writeObject(PemObject("CERTIFICATE", cert.encoded));
        pemCertWriter.close();

        val privateKeyFile = generateLocalFile("privateKey", privateKeyWriter.toString())
        val certFile = generateLocalFile("cert", certWriter.toString())

        val zipFile = generateZipFile(privateKeyFile, certFile)

        privateKeyFile.delete()
        certFile.delete()

        return zipFile
    }

    private fun generateLocalFile(fileName: String, content: String): File {
        val file = File.createTempFile(fileName, ".pem")
        file.writeText(content)
        return file
    }

    private fun generateZipFile(vararg files: File): ByteArray {
        val baos = ByteArrayOutputStream();
        val zos = ZipOutputStream(baos);

        files.forEach { file ->
            zos.putNextEntry(java.util.zip.ZipEntry(file.name));
            zos.write(file.readBytes());
            zos.closeEntry();
        }

        zos.finish();
        zos.close();

        return baos.toByteArray();
    }
}