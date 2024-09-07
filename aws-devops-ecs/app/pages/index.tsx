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
          Welcome to <a href="https://nextjs.org">Next.js!</a>
        </h1>
        <p>
          Hello World from CC Tech!
        </p>
        <p>
          Database Status: {dbStatus}
        </p>
      </main>
    </div>
  )
}