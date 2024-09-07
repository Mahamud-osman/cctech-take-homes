// File: pages/index.tsx
import { useState, useEffect } from 'react'

export default function Home() {
  const [dbStatus, setDbStatus] = useState<string>('Checking...')

  useEffect(() => {
    fetch('/api/db-check')
      .then(res => res.json())
      .then(data => setDbStatus(data.message))
      .catch(() => setDbStatus('Failed to connect to database'))
  }, [])

  return (
    <div>
      <main>
        <h1>
          Welcome to CC Tech DevSecOps Challenge
        </h1>
        <p>
          Innovating with Security and Efficiency
        </p>
        <p>
          Database Connection Status: {dbStatus} 
        </p>
        <p>
          This sample application demonstrates a basic Next.js setup with database connectivity.
        </p>
        <p>
          Your task is to deploy this securely in an AWS environment. Good luck!
        </p>
      </main>
    </div>
  )
}