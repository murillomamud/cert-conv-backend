# Digital Certificate Conversion

## Description
This project is a simple tool to convert a digital certificate from pfx to pem format.

### How to use
1. Clone the project
2. Build the docker image with the command `docker build -t certificate-conversion .`
3. Run the docker image with the command `docker run -p 8080:8080 -d certificate-conversion`
4. Access the endpoint `http://localhost:8080/convert` using form-data with the following parameters:
    - file: the pfx file
    - password: the password of the pfx file
5. Example call using curl:
    - `curl --location --request POST 'http://localhost:8080/convert' \
    --form 'file=@"/path/to/file.pfx"' \
    --form 'password="password"'`