const axios = require('axios');
const fs = require('fs');
const csv = require('csv-parser');

const STRAPI_API_URL = 'http://172.22.0.244:8008/';
const API_TOKEN = 'cd479fc898c67869c78bd1315d9ddb3c8e4167b5cb1b6abaf33d8ea4e0826aa81c29ddc656c9a6fb8c73a2ec7889f13f6d7076f05ed5478953a1d43b20cb7001b8607d3d9d86821b6ef7a3b66e14c9a752d932cdd6f8a8d710468d9e50a08558190b6b00f2e983918fc38890d6d3ffe5e8397e77ba9c8c056663dc885b908451';

const createFertilizer = async (fertilizerData) => {
    try {
        // Validate the URL format
        const apiUrl = new URL('/api/fertilizers', STRAPI_API_URL).toString();

        // Check if fertilizer exists
        const checkResponse = await axios.get(apiUrl, {
            params: {
                'filters[Name][$eq]': fertilizerData.title
            },
            headers: { 
                'Authorization': `Bearer ${API_TOKEN}`,
                'Content-Type': 'application/json'
            },
        });

        if (checkResponse.data.data?.length > 0) {
            console.log(`Fertilizer "${fertilizerData.title}" already exists.`);
            return checkResponse.data.data[0].id;
        }

        // Create new fertilizer with validated data
        const createResponse = await axios.post(
            apiUrl,
            {
                data: {
                    Name: fertilizerData.title.trim(),
                    Type: fertilizerData.fertilizer_type.trim(),
                    Url: fertilizerData.product_link.trim(),
                    Price: Number(fertilizerData.price) || 0
                }
            },
            { 
                headers: { 
                    'Authorization': `Bearer ${API_TOKEN}`,
                    'Content-Type': 'application/json'
                } 
            }
        );

        console.log(`Created Fertilizer: "${fertilizerData.title}"`);
        return createResponse.data.data.id;

    } catch (error) {
        if (error.response?.status === 404) {
            console.error('API endpoint not found. Please check your STRAPI_API_URL configuration.');
        } else {
            console.error(`Error with Fertilizer "${fertilizerData.title}":`, 
                error.response?.data || error.message);
        }
        return null;
    }
};

const processCSV = (filePath) => {
    const records = [];
    
    fs.createReadStream(filePath)
        .pipe(csv())
        .on('headers', (headers) => {
            const requiredHeaders = ['title', 'price', 'product_link', 'fertilizer_type'];
            const missingHeaders = requiredHeaders.filter(h => !headers.includes(h));
            if (missingHeaders.length > 0) {
                throw new Error(`Missing required headers: ${missingHeaders.join(', ')}`);
            }
        })
        .on('data', (row) => records.push(row))
        .on('end', async () => {
            for (const record of records) {
                await createFertilizer(record);
            }
            console.log('Finished processing fertilizers.');
        })
        .on('error', (error) => {
            console.error('Error processing CSV:', error);
        });
};

// Start processing
processCSV('fertilizers.csv');