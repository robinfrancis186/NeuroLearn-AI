#!/bin/bash

# NeuroLearn AI LangChain Backend Setup Script
echo "🚀 Setting up NeuroLearn AI LangChain Backend..."

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "✅ Python found: $(python3 --version)"

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔧 Activating virtual environment..."
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚙️  Creating .env file from template..."
    cp .env.example .env
    echo ""
    echo "🔑 Please edit .env file and add your OpenAI API key:"
    echo "   OPENAI_API_KEY=your_openai_api_key_here"
    echo ""
    read -p "Press Enter to continue once you've added your API key..."
fi

# Check if API key is set
if grep -q "your_openai_api_key_here" .env; then
    echo "⚠️  Warning: Please update your OpenAI API key in .env file"
    echo "   Current: OPENAI_API_KEY=your_openai_api_key_here"
    echo ""
fi

echo "✅ Setup complete!"
echo ""
echo "🏃 To start the LangChain backend:"
echo "   python main.py"
echo ""
echo "🧪 To test the LangChain flows:"
echo "   python examples/test_requests.py"
echo ""
echo "📚 The backend will be available at: http://localhost:8000"
echo "📖 API documentation will be at: http://localhost:8000/docs" 